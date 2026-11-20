import 'package:nexbanak/app/constants/api_endpoints.dart';
import 'package:nexbanak/core/network/api_client.dart';
import 'package:nexbanak/data/models/account_model.dart';
import 'package:nexbanak/data/models/banking_models.dart';
import 'package:nexbanak/data/models/dashboard_models.dart';
import 'package:nexbanak/data/models/notification_model.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:nexbanak/data/models/user_model.dart';
import 'package:nexbanak/data/providers/demo_data_source.dart';
import 'package:nexbanak/data/repositories/repository_helpers.dart';

abstract class BankingRepository {
  Future<List<AccountModel>> accounts();
  Future<AccountModel> account(String id);
  Future<AccountModel> accountByNumber(String number);
  Future<AccountModel> requestAccount(String type, String name);
  Future<CustomerStats> customerStats();
  Future<List<TransactionModel>> transactions({
    String? accountId,
    String? type,
    String? status,
    String? search,
    int? limit,
  });
  Future<TransactionModel> transaction(String id);
  Future<TransactionModel> createDeposit({
    required String accountId,
    required String amount,
    required String note,
    required String idempotencyKey,
  });
  Future<TransactionModel> createWithdrawal({
    required String accountId,
    required String amount,
    required String note,
    required String idempotencyKey,
  });
  Future<TransactionModel> createTransfer({
    required String fromAccountId,
    required String toAccountNumber,
    required String amount,
    required String note,
    required String otp,
    required String idempotencyKey,
  });
  Future<List<BeneficiaryModel>> beneficiaries();
  Future<BeneficiaryModel> addBeneficiary({
    required String name,
    required String accountNumber,
    required String bank,
    required String nickname,
  });
  Future<void> deleteBeneficiary(String id);
  Future<List<LoanModel>> loans();
  Future<LoanModel> applyLoan({
    required String type,
    required String amount,
    required int termMonths,
  });
  Future<TransactionModel> repayLoan(String loanId, String amount);
  Future<List<CardModel>> cards();
  Future<CardModel> setCardStatus(String id, String status);
  Future<List<SavingsGoalModel>> savingsGoals();
  Future<SavingsGoalModel> addSavingsGoal({
    required String name,
    required String target,
    required String deadline,
  });
  Future<List<FixedDepositModel>> fixedDeposits();
  Future<FixedDepositModel> openFixedDeposit({
    required String amount,
    required int termMonths,
  });
  Future<TransactionModel> createBillPayment({
    required String accountId,
    required String billerName,
    required String customerCode,
    required String amount,
    required String note,
  });
  Future<TransactionModel> createMobileTopup({
    required String accountId,
    required String operatorName,
    required String mobileNumber,
    required String amount,
  });
  Future<TransactionModel> createMfsTransfer({
    required String accountId,
    required String mfsProvider,
    required String recipientMobile,
    required String amount,
  });
  Future<List<NotificationModel>> notifications();
  Future<void> markNotificationRead(String id);
  Future<void> markAllNotificationsRead();
  Future<UserModel> updateProfile(String id, {String? name, String? phone});
}

class RemoteBankingRepository implements BankingRepository {
  RemoteBankingRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<AccountModel>> accounts() async {
    final Map<String, dynamic> body = await _api.get(ApiEndpoints.accounts);
    return extractList(body, 'accounts')
        .map(AccountModel.fromJson)
        .toList();
  }

  @override
  Future<AccountModel> account(String id) async => AccountModel.fromJson(
        extractMap(await _api.get('${ApiEndpoints.accounts}/$id'), 'account'),
      );

  @override
  Future<AccountModel> accountByNumber(String number) async {
    final Map<String, dynamic> body = await _api.get(
      ApiEndpoints.accounts,
      query: <String, dynamic>{'number': number},
    );
    final List<AccountModel> found =
        extractList(body, 'accounts').map(AccountModel.fromJson).toList();
    if (found.isEmpty) {
      throw StateError('Recipient account not found');
    }
    return found.first;
  }

  @override
  Future<AccountModel> requestAccount(String type, String name) async =>
      AccountModel.fromJson(extractMap(
        await _api.post(
          ApiEndpoints.accountRequests,
          data: <String, dynamic>{'type': type, 'name': name},
        ),
        'account',
      ));

  @override
  Future<CustomerStats> customerStats() async => CustomerStats.fromJson(
        extractMap(await _api.get('${ApiEndpoints.accounts}/stats'), 'stats'),
      );

  @override
  Future<List<TransactionModel>> transactions({
    String? accountId,
    String? type,
    String? status,
    String? search,
    int? limit,
  }) async {
    final Map<String, dynamic> query = <String, dynamic>{
      'accountId': ?accountId,
      'type': ?(type == 'all' ? null : type),
      'status': ?(status == 'all' ? null : status),
      'search': ?(search?.isEmpty == true ? null : search),
      'limit': ?limit,
    };
    final Map<String, dynamic> body =
        await _api.get(ApiEndpoints.transactions, query: query);
    return extractList(body, 'transactions').map(TransactionModel.fromJson).toList();
  }

  @override
  Future<TransactionModel> transaction(String id) async =>
      TransactionModel.fromJson(
        extractMap(await _api.get('${ApiEndpoints.transactions}/$id'), 'transaction'),
      );

  @override
  Future<TransactionModel> createDeposit({
    required String accountId,
    required String amount,
    required String note,
    required String idempotencyKey,
  }) async =>
      TransactionModel.fromJson(extractMap(
        await _api.post(ApiEndpoints.deposits,
            data: <String, dynamic>{
              'accountId': accountId, 'amount': amount, 'note': note,
            }),
        'transaction',
      ));

  @override
  Future<TransactionModel> createWithdrawal({
    required String accountId,
    required String amount,
    required String note,
    required String idempotencyKey,
  }) async =>
      TransactionModel.fromJson(extractMap(
        await _api.post(ApiEndpoints.withdrawals,
            data: <String, dynamic>{
              'accountId': accountId, 'amount': amount, 'note': note,
            }),
        'transaction',
      ));

  @override
  Future<TransactionModel> createTransfer({
    required String fromAccountId,
    required String toAccountNumber,
    required String amount,
    required String note,
    required String otp,
    required String idempotencyKey,
  }) async =>
      TransactionModel.fromJson(extractMap(
        await _api.post(ApiEndpoints.transfers,
            data: <String, dynamic>{
              'fromAccountId': fromAccountId,
              'toAccountNumber': toAccountNumber,
              'amount': amount,
              'note': note,
              'otp': otp,
            }),
        'transaction',
      ));

  @override
  Future<List<BeneficiaryModel>> beneficiaries() async {
    final Map<String, dynamic> body = await _api.get(ApiEndpoints.beneficiaries);
    return extractList(body, 'beneficiaries').map(BeneficiaryModel.fromJson).toList();
  }

  @override
  Future<BeneficiaryModel> addBeneficiary({
    required String name,
    required String accountNumber,
    required String bank,
    required String nickname,
  }) async =>
      BeneficiaryModel.fromJson(extractMap(
        await _api.post(ApiEndpoints.beneficiaries,
            data: <String, dynamic>{
              'name': name, 'accountNumber': accountNumber,
              'bank': bank, 'nickname': nickname,
            }),
        'beneficiary',
      ));

  @override
  Future<void> deleteBeneficiary(String id) =>
      _api.delete('${ApiEndpoints.beneficiaries}/$id');

  @override
  Future<List<LoanModel>> loans() async {
    final Map<String, dynamic> body = await _api.get(ApiEndpoints.loans);
    return extractList(body, 'loans').map(LoanModel.fromJson).toList();
  }

  @override
  Future<LoanModel> applyLoan({
    required String type,
    required String amount,
    required int termMonths,
  }) async =>
      LoanModel.fromJson(extractMap(
        await _api.post(ApiEndpoints.loans,
            data: <String, dynamic>{
              'type': type, 'amount': amount, 'termMonths': termMonths,
            }),
        'loan',
      ));

  @override
  Future<TransactionModel> repayLoan(String loanId, String amount) async =>
      TransactionModel.fromJson(extractMap(
        await _api.post('${ApiEndpoints.loans}/$loanId/repay',
            data: <String, dynamic>{'amount': amount}),
        'transaction',
      ));

  @override
  Future<List<CardModel>> cards() async {
    final Map<String, dynamic> body = await _api.get(ApiEndpoints.cards);
    return extractList(body, 'cards').map(CardModel.fromJson).toList();
  }

  @override
  Future<CardModel> setCardStatus(String id, String status) async =>
      CardModel.fromJson(extractMap(
        await _api.patch('${ApiEndpoints.cards}/$id/status',
            data: <String, dynamic>{'status': status}),
        'card',
      ));

  @override
  Future<List<SavingsGoalModel>> savingsGoals() async {
    final Map<String, dynamic> body = await _api.get(ApiEndpoints.savingsGoals);
    return extractList(body, 'goals').map(SavingsGoalModel.fromJson).toList();
  }

  @override
  Future<SavingsGoalModel> addSavingsGoal({
    required String name,
    required String target,
    required String deadline,
  }) async =>
      SavingsGoalModel.fromJson(extractMap(
        await _api.post(ApiEndpoints.savingsGoals,
            data: <String, dynamic>{
              'name': name, 'target': target, 'deadline': deadline,
            }),
        'goal',
      ));

  @override
  Future<List<FixedDepositModel>> fixedDeposits() async {
    final Map<String, dynamic> body = await _api.get(ApiEndpoints.fixedDeposits);
    return extractList(body, 'deposits').map(FixedDepositModel.fromJson).toList();
  }

  @override
  Future<FixedDepositModel> openFixedDeposit({
    required String amount,
    required int termMonths,
  }) async =>
      FixedDepositModel.fromJson(extractMap(
        await _api.post(ApiEndpoints.fixedDeposits,
            data: <String, dynamic>{'amount': amount, 'termMonths': termMonths}),
        'deposit',
      ));

  @override
  Future<TransactionModel> createBillPayment({
    required String accountId,
    required String billerName,
    required String customerCode,
    required String amount,
    required String note,
  }) async =>
      TransactionModel.fromJson(extractMap(
        await _api.post('/bills/pay', data: <String, dynamic>{
          'accountId': accountId,
          'billerName': billerName,
          'customerCode': customerCode,
          'amount': amount,
          'note': note,
        }),
        'transaction',
      ));

  @override
  Future<TransactionModel> createMobileTopup({
    required String accountId,
    required String operatorName,
    required String mobileNumber,
    required String amount,
  }) async =>
      TransactionModel.fromJson(extractMap(
        await _api.post('/topup', data: <String, dynamic>{
          'accountId': accountId,
          'operatorName': operatorName,
          'mobileNumber': mobileNumber,
          'amount': amount,
        }),
        'transaction',
      ));

  @override
  Future<TransactionModel> createMfsTransfer({
    required String accountId,
    required String mfsProvider,
    required String recipientMobile,
    required String amount,
  }) async =>
      TransactionModel.fromJson(extractMap(
        await _api.post('/mfs/transfer', data: <String, dynamic>{
          'accountId': accountId,
          'mfsProvider': mfsProvider,
          'recipientMobile': recipientMobile,
          'amount': amount,
        }),
        'transaction',
      ));

  @override
  Future<List<NotificationModel>> notifications() async {
    final Map<String, dynamic> body = await _api.get(ApiEndpoints.notifications);
    return extractList(body, 'notifications').map(NotificationModel.fromJson).toList();
  }

  @override
  Future<void> markNotificationRead(String id) =>
      _api.patch('${ApiEndpoints.notifications}/$id/read');

  @override
  Future<void> markAllNotificationsRead() =>
      _api.patch('${ApiEndpoints.notifications}/read-all');

  @override
  Future<UserModel> updateProfile(String id, {String? name, String? phone}) async =>
      UserModel.fromJson(extractMap(
        await _api.patch('${ApiEndpoints.customers}/$id',
            data: <String, dynamic>{
              'name': ?name,
              'phone': ?phone,
            }),
        'user',
      ));
}

class DemoBankingRepository implements BankingRepository {
  DemoBankingRepository(this._demo);

  final DemoDataSource _demo;

  @override
  Future<List<AccountModel>> accounts() => _demo.accounts();
  @override
  Future<AccountModel> account(String id) => _demo.account(id);
  @override
  Future<AccountModel> accountByNumber(String number) => _demo.accountByNumber(number);
  @override
  Future<AccountModel> requestAccount(String type, String name) =>
      _demo.requestAccount(type, name);
  @override
  Future<CustomerStats> customerStats() => _demo.customerStats();
  @override
  Future<List<TransactionModel>> transactions({
    String? accountId,
    String? type,
    String? status,
    String? search,
    int? limit,
  }) =>
      _demo.transactions(
        accountId: accountId, type: type, status: status,
        search: search, limit: limit,
      );
  @override
  Future<TransactionModel> transaction(String id) => _demo.transaction(id);
  @override
  Future<TransactionModel> createDeposit({
    required String accountId,
    required String amount,
    required String note,
    required String idempotencyKey,
  }) =>
      _demo.createDeposit(
        accountId: accountId, amount: amount, note: note,
        idempotencyKey: idempotencyKey,
      );
  @override
  Future<TransactionModel> createWithdrawal({
    required String accountId,
    required String amount,
    required String note,
    required String idempotencyKey,
  }) =>
      _demo.createWithdrawal(
        accountId: accountId, amount: amount, note: note,
        idempotencyKey: idempotencyKey,
      );
  @override
  Future<TransactionModel> createTransfer({
    required String fromAccountId,
    required String toAccountNumber,
    required String amount,
    required String note,
    required String otp,
    required String idempotencyKey,
  }) =>
      _demo.createTransfer(
        fromAccountId: fromAccountId, toAccountNumber: toAccountNumber,
        amount: amount, note: note, otp: otp, idempotencyKey: idempotencyKey,
      );
  @override
  Future<List<BeneficiaryModel>> beneficiaries() => _demo.beneficiaries();
  @override
  Future<BeneficiaryModel> addBeneficiary({
    required String name,
    required String accountNumber,
    required String bank,
    required String nickname,
  }) =>
      _demo.addBeneficiary(
        name: name, accountNumber: accountNumber, bank: bank, nickname: nickname,
      );
  @override
  Future<void> deleteBeneficiary(String id) => _demo.deleteBeneficiary(id);
  @override
  Future<List<LoanModel>> loans() => _demo.loans();
  @override
  Future<LoanModel> applyLoan({
    required String type,
    required String amount,
    required int termMonths,
  }) =>
      _demo.applyLoan(type: type, amount: amount, termMonths: termMonths);
  @override
  Future<TransactionModel> repayLoan(String loanId, String amount) =>
      _demo.repayLoan(loanId, amount);
  @override
  Future<List<CardModel>> cards() => _demo.cards();
  @override
  Future<CardModel> setCardStatus(String id, String status) =>
      _demo.setCardStatus(id, status);
  @override
  Future<List<SavingsGoalModel>> savingsGoals() => _demo.savingsGoals();
  @override
  Future<SavingsGoalModel> addSavingsGoal({
    required String name,
    required String target,
    required String deadline,
  }) =>
      _demo.addSavingsGoal(name: name, target: target, deadline: deadline);
  @override
  Future<List<FixedDepositModel>> fixedDeposits() => _demo.fixedDeposits();
  @override
  Future<FixedDepositModel> openFixedDeposit({
    required String amount,
    required int termMonths,
  }) =>
      _demo.openFixedDeposit(amount: amount, termMonths: termMonths);
  @override
  Future<TransactionModel> createBillPayment({
    required String accountId,
    required String billerName,
    required String customerCode,
    required String amount,
    required String note,
  }) =>
      _demo.createBillPayment(
        accountId: accountId, billerName: billerName, customerCode: customerCode,
        amount: amount, note: note,
      );
  @override
  Future<TransactionModel> createMobileTopup({
    required String accountId,
    required String operatorName,
    required String mobileNumber,
    required String amount,
  }) =>
      _demo.createMobileTopup(
        accountId: accountId, operatorName: operatorName, mobileNumber: mobileNumber,
        amount: amount,
      );
  @override
  Future<TransactionModel> createMfsTransfer({
    required String accountId,
    required String mfsProvider,
    required String recipientMobile,
    required String amount,
  }) =>
      _demo.createMfsTransfer(
        accountId: accountId, mfsProvider: mfsProvider, recipientMobile: recipientMobile,
        amount: amount,
      );
  @override
  Future<List<NotificationModel>> notifications() => _demo.notifications();
  @override
  Future<void> markNotificationRead(String id) => _demo.markNotificationRead(id);
  @override
  Future<void> markAllNotificationsRead() => _demo.markAllNotificationsRead();
  @override
  Future<UserModel> updateProfile(String id, {String? name, String? phone}) =>
      _demo.updateProfile(id, name: name, phone: phone);
}
