import 'package:flutter_test/flutter_test.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/core/errors/app_exception.dart';
import 'package:nexbanak/data/providers/demo_data_source.dart';
import 'package:nexbanak/data/repositories/admin_repository.dart';
import 'package:nexbanak/data/repositories/banking_repository.dart';

void main() {
  late DemoDataSource demo;
  late DemoBankingRepository banking;
  late DemoAdminRepository admin;

  setUp(() {
    demo = DemoDataSource();
    banking = DemoBankingRepository(demo);
    admin = DemoAdminRepository(demo);
  });

  Matcher codeIs(String code) => isA<AppException>()
      .having((AppException e) => e.code, 'code', code);

  test('deposit is pending, audited, and does not change the ledger balance',
      () async {
    final before = await banking.account('acc_001');
    final txn = await banking.createDeposit(
      accountId: 'acc_001',
      amount: '250.00',
      note: 'Demo counter deposit',
      idempotencyKey: 'test-deposit-001',
    );

    expect(txn.type, 'deposit');
    expect(txn.direction, 'credit');
    expect(txn.status, 'pending');
    expect(txn.amount, '250.00');
    expect(txn.reference, startsWith('NXB-'));

    final after = await banking.account('acc_001');
    expect(after.balance, before.balance,
        reason: 'Pending deposits must never be posted client-side');

    final pending = await banking.transactions(status: 'pending');
    expect(pending.map((t) => t.id), contains(txn.id));
    final audit = await admin.auditLogs();
    expect(audit, isNotEmpty);
    expect(audit.first.action, 'DEPOSIT_REQUEST');
    expect(audit.first.target, txn.reference);
  });

  test('duplicate idempotency keys are rejected without a second request',
      () async {
    await banking.createDeposit(
      accountId: 'acc_001',
      amount: '10.00',
      note: 'First attempt',
      idempotencyKey: 'test-deposit-duplicate',
    );
    final before = await banking.transactions(type: 'deposit');

    await expectLater(
      banking.createDeposit(
        accountId: 'acc_001',
        amount: '10.00',
        note: 'Retry with same key',
        idempotencyKey: 'test-deposit-duplicate',
      ),
      throwsA(codeIs('DUPLICATE_REQUEST')),
    );
    final after = await banking.transactions(type: 'deposit');
    expect(after.length, before.length);
  });

  test('withdrawal is pending and enforces balance and per-transaction limits',
      () async {
    final before = await banking.account('acc_001');
    final txn = await banking.createWithdrawal(
      accountId: 'acc_001',
      amount: '125.00',
      note: 'Demo cash withdrawal',
      idempotencyKey: 'test-withdrawal-001',
    );

    expect(txn.type, 'withdrawal');
    expect(txn.direction, 'debit');
    expect(txn.status, 'pending');
    expect((await banking.account('acc_001')).balance, before.balance);

    await expectLater(
      banking.createWithdrawal(
        accountId: 'acc_001',
        amount: '99999.00',
        note: 'Too much',
        idempotencyKey: 'test-withdrawal-funds',
      ),
      throwsA(codeIs('INSUFFICIENT_FUNDS')),
    );
    await expectLater(
      banking.createWithdrawal(
        accountId: 'acc_001',
        amount: '5000.01',
        note: 'Over the limit',
        idempotencyKey: 'test-withdrawal-limit',
      ),
      throwsA(codeIs('LIMIT_EXCEEDED')),
    );
  });

  test('OTP-verified transfer debits and credits decimal balances exactly',
      () async {
    final sourceBefore = await banking.account('acc_001');
    final destinationBefore = await banking.account('acc_002');

    final txn = await banking.createTransfer(
      fromAccountId: 'acc_001',
      toAccountNumber: '1002003002',
      amount: '100.25',
      note: 'Demo transfer',
      otp: AppConstants.otpDemoCode,
      idempotencyKey: 'test-transfer-001',
    );

    expect(txn.type, 'transfer');
    expect(txn.status, 'completed');
    expect((await banking.account('acc_001')).balance, '8140.50');
    expect((await banking.account('acc_002')).balance, '3220.65');
    expect(sourceBefore.balance, '8240.75');
    expect(destinationBefore.balance, '3120.40');

    final audit = await admin.auditLogs(search: 'TRANSFER');
    expect(audit, isNotEmpty);
    expect(audit.first.target, txn.reference);
  });

  test('invalid OTP and same-account transfers leave balances untouched',
      () async {
    final before = await banking.account('acc_001');

    await expectLater(
      banking.createTransfer(
        fromAccountId: 'acc_001',
        toAccountNumber: '1002003002',
        amount: '50.00',
        note: 'Bad OTP',
        otp: '000000',
        idempotencyKey: 'test-transfer-bad-otp',
      ),
      throwsA(codeIs('INVALID_OTP')),
    );
    await expectLater(
      banking.createTransfer(
        fromAccountId: 'acc_001',
        toAccountNumber: '1002003001',
        amount: '50.00',
        note: 'Same account',
        otp: AppConstants.otpDemoCode,
        idempotencyKey: 'test-transfer-same',
      ),
      throwsA(codeIs('SAME_ACCOUNT')),
    );

    expect((await banking.account('acc_001')).balance, before.balance);
  });

  test('transaction list filters by type, status, and search text', () async {
    final deposits = await banking.transactions(type: 'deposit');
    expect(deposits, isNotEmpty);
    expect(deposits.every((t) => t.type == 'deposit'), isTrue);

    final limited = await banking.transactions(limit: 3);
    expect(limited.length, 3);

    final searched = await banking.transactions(search: 'Netflix');
    expect(searched.length, 1);
    expect(searched.single.title, contains('Netflix'));

    final txn = await banking.transaction('NXB-901201');
    expect(txn.id, 'txn_001');
    expect(txn.isCredit, isTrue);
    expect(txn.isCompleted, isTrue);
  });

  test('approvals enforce maker-checker separation and audit decisions',
      () async {
    final pending = await admin.approvals(status: 'pending');
    final own = pending.firstWhere((item) => item.id == 'apr_001');
    expect(own.madeBy, 'usr_e_002');

    await expectLater(
      admin.approve(own.id, own.madeBy),
      throwsA(codeIs('SELF_APPROVAL')),
    );
    expect(
      (await admin.approvals(status: 'pending')).map((i) => i.id),
      contains('apr_001'),
    );

    await admin.approve(own.id, 'usr_a_001');
    expect(
      (await admin.approvals(status: 'approved')).map((i) => i.id),
      contains('apr_001'),
    );
    final audit = await admin.auditLogs(search: 'APPROVE_DEPOSIT');
    expect(audit, isNotEmpty);
    expect(audit.first.actor, 'usr_a_001');

    await expectLater(
      admin.reject('apr_002', 'usr_a_001', '   '),
      throwsA(codeIs('VALIDATION')),
    );
  });

  test('requested accounts remain pending until a checker acts', () async {
    final account = await banking.requestAccount('current', 'Demo Current');
    expect(account.status, 'pending');
    expect(account.balance, '0.00');
    expect(
      (await admin.approvals(type: 'account', status: 'pending')).map((i) => i.id),
      contains('apr_5'),
    );
  });
}
