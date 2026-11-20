import 'dart:convert';
import 'dart:math';

import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/core/errors/app_exception.dart';
import 'package:nexbanak/core/services/storage_service.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/data/models/account_model.dart';
import 'package:nexbanak/data/models/admin_models.dart';
import 'package:nexbanak/data/models/banking_models.dart';
import 'package:nexbanak/data/models/dashboard_models.dart';
import 'package:nexbanak/data/models/notification_model.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:nexbanak/data/models/user_model.dart';

class DemoDataSource {
  DemoDataSource() {
    _seed();
    _loadFromStorage();
  }

  late final List<UserModel> _users;
  late final Map<String, String> _passwords;
  late final List<AccountModel> _accounts;
  late final List<TransactionModel> _transactions;
  late final List<BeneficiaryModel> _beneficiaries;
  late final List<LoanModel> _loans;
  late final List<CardModel> _cards;
  late final List<NotificationModel> _notifications;
  late final List<SavingsGoalModel> _goals;
  late final List<FixedDepositModel> _fixedDeposits;
  late final List<PersonRecord> _customers;
  late final List<PersonRecord> _employees;
  late final List<BranchRecord> _branches;
  late final List<ApprovalItem> _approvals;
  late final List<KycRecord> _kyc;
  late final List<AuditEvent> _audit;
  final Set<String> _usedIdempotencyKeys = <String>{};
  final Map<String, String> _otps = <String, String>{};
  final Map<String, String> _resetTokens = <String, String>{};
  final Random _random = Random();

  static const String demoCustomerEmail = 'customer@nexbank.demo';
  static const String demoEmployeeEmail = 'employee@nexbank.demo';
  static const String demoAdminEmail = 'admin@nexbank.demo';
  static const String demoPassword = 'Demo@123';

  Future<void> _latency() =>
      Future<void>.delayed(const Duration(milliseconds: 120));

  void _seed() {
    _users = <UserModel>[
      UserModel(
        id: 'usr_c_001', name: 'Alex Morgan', email: demoCustomerEmail,
        role: AppRole.customer, phone: '+1 555 0101', customerId: 'cus_001',
      ),
      UserModel(
        id: 'usr_e_001', name: 'Priya Shah', email: demoEmployeeEmail,
        role: AppRole.employee, phone: '+1 555 0102', employeeId: 'emp_001',
      ),
      UserModel(
        id: 'usr_a_001', name: 'Jordan Lee', email: demoAdminEmail,
        role: AppRole.admin, phone: '+1 555 0103', employeeId: 'emp_000',
      ),
    ];
    _passwords = <String, String>{
      for (UserModel u in _users) u.email: demoPassword,
    };

    _accounts = <AccountModel>[
      AccountModel(
        id: 'acc_001', accountNumber: '1002003001', name: 'Premium Savings',
        type: 'savings', balance: '8240.75', currency: 'USD', status: 'active',
        openedAt: '2023-02-14', interestRate: '4.25',
      ),
      AccountModel(
        id: 'acc_002', accountNumber: '1002003002', name: 'Everyday Current',
        type: 'current', balance: '3120.40', currency: 'USD', status: 'active',
        openedAt: '2023-08-03',
      ),
    ];

    final DateTime now = DateTime.now();
    String day(int offset) =>
        now.subtract(Duration(days: offset)).toIso8601String();
    _transactions = <TransactionModel>[
      TransactionModel(id: 'txn_001', reference: 'NXB-901201', title: 'Salary — Acme Corp', type: 'deposit', amount: '4200.00', direction: 'credit', status: 'completed', date: day(1), category: 'Income'),
      TransactionModel(id: 'txn_002', reference: 'NXB-901200', title: 'Apple Store', type: 'card', amount: '129.99', direction: 'debit', status: 'completed', date: day(2), category: 'Shopping'),
      TransactionModel(id: 'txn_003', reference: 'NXB-901199', title: 'Transfer to Maria Santos', type: 'transfer', amount: '350.00', direction: 'debit', status: 'completed', date: day(3), counterparty: 'Maria Santos', category: 'Transfer'),
      TransactionModel(id: 'txn_004', reference: 'NXB-901198', title: 'Grocery Market', type: 'card', amount: '86.40', direction: 'debit', status: 'completed', date: day(5), category: 'Groceries'),
      TransactionModel(id: 'txn_005', reference: 'NXB-901197', title: 'Cash deposit', type: 'deposit', amount: '500.00', direction: 'credit', status: 'completed', date: day(7), category: 'Deposit'),
      TransactionModel(id: 'txn_006', reference: 'NXB-901196', title: 'Netflix subscription', type: 'card', amount: '15.99', direction: 'debit', status: 'completed', date: day(9), category: 'Bills'),
      TransactionModel(id: 'txn_007', reference: 'NXB-901195', title: 'Freelance payment', type: 'deposit', amount: '1250.00', direction: 'credit', status: 'completed', date: day(12), category: 'Income'),
      TransactionModel(id: 'txn_008', reference: 'NXB-901194', title: 'ATM withdrawal', type: 'withdrawal', amount: '200.00', direction: 'debit', status: 'completed', date: day(15), category: 'Cash'),
      TransactionModel(id: 'txn_009', reference: 'NXB-901193', title: 'Electricity bill', type: 'card', amount: '112.30', direction: 'debit', status: 'completed', date: day(21), category: 'Bills'),
      TransactionModel(id: 'txn_010', reference: 'NXB-901192', title: 'Loan repayment', type: 'loan', amount: '289.00', direction: 'debit', status: 'completed', date: day(28), category: 'Loan'),
    ];

    _beneficiaries = <BeneficiaryModel>[
      BeneficiaryModel(id: 'ben_001', name: 'Maria Santos', accountNumber: '2003004001', bank: 'NEXBANK', nickname: 'Family'),
      BeneficiaryModel(id: 'ben_002', name: 'Daniel Kim', accountNumber: '2003004002', bank: 'NEXBANK', nickname: 'Rent'),
      BeneficiaryModel(id: 'ben_003', name: 'Sofia Rossi', accountNumber: '3004005003', bank: 'City Bank', nickname: 'Business'),
      BeneficiaryModel(id: 'ben_004', name: 'Noah Williams', accountNumber: '2003004004', bank: 'NEXBANK'),
    ];

    _loans = <LoanModel>[
      LoanModel(id: 'loan_001', type: 'Personal loan', amount: '12000', outstanding: '4310.00', status: 'active', appliedAt: day(120), nextDueDate: day(-10)),
      LoanModel(id: 'loan_002', type: 'Auto loan', amount: '28000', outstanding: '18650.00', status: 'active', appliedAt: day(300), nextDueDate: day(-18)),
    ];

    _cards = <CardModel>[
      CardModel(id: 'card_001', type: 'debit', last4: '4821', holder: 'ALEX MORGAN', expiry: '09/28', status: 'active'),
      CardModel(id: 'card_002', type: 'credit', last4: '9136', holder: 'ALEX MORGAN', expiry: '03/27', status: 'active', limit: '12000'),
    ];

    _notifications = <NotificationModel>[
      NotificationModel(id: 'ntf_001', title: 'Salary received', body: 'A deposit of \$4,200.00 was credited to Premium Savings.', time: day(1), type: 'transaction', isRead: false),
      NotificationModel(id: 'ntf_002', title: 'Security alert', body: 'New sign-in from Chrome on macOS.', time: day(2), type: 'security', isRead: false),
      NotificationModel(id: 'ntf_003', title: 'Loan payment due', body: 'Your next personal loan payment is due soon.', time: day(4), type: 'system', isRead: true),
      NotificationModel(id: 'ntf_004', title: 'New debit card ready', body: 'Your replacement debit card has been dispatched.', time: day(11), type: 'system', isRead: true),
    ];

    _goals = <SavingsGoalModel>[
      SavingsGoalModel(id: 'goal_001', name: 'Japan trip', target: '8000', saved: '5250', deadline: '2027-04-01'),
      SavingsGoalModel(id: 'goal_002', name: 'Emergency fund', target: '15000', saved: '9800', deadline: '2027-12-31'),
    ];

    _fixedDeposits = <FixedDepositModel>[
      FixedDepositModel(id: 'fd_001', amount: '5000', termMonths: 12, rate: '6.50', status: 'active', startedAt: day(60)),
    ];

    _customers = List<PersonRecord>.generate(24, (i) => PersonRecord(
          id: 'cus_${(i + 1).toString().padLeft(3, '0')}',
          name: '${<String>['Maria Santos', 'Daniel Kim', 'Sofia Rossi', 'Noah Williams', 'Emma Brown', 'Liam Chen'][i % 6]} ${i + 1}',
          email: 'customer${i + 1}@example.com',
          phone: '+1 555 ${(1000 + i).toString()}',
          status: i % 11 == 0 ? 'pending' : 'active',
          kyc: i % 7 == 0 ? 'pending' : 'verified',
          joinedAt: day(30 + i * 9).substring(0, 10),
        ));

    _employees = <PersonRecord>[
      PersonRecord(id: 'emp_001', name: 'Priya Shah', email: demoEmployeeEmail, phone: '+1 555 0102', status: 'active', role: 'EMPLOYEE', branch: 'Downtown Branch'),
      PersonRecord(id: 'emp_002', name: 'Owen Carter', email: 'owen@nexbank.demo', phone: '+1 555 0112', status: 'active', role: 'EMPLOYEE', branch: 'Westside Branch'),
      PersonRecord(id: 'emp_003', name: 'Aisha Noor', email: 'aisha@nexbank.demo', phone: '+1 555 0113', status: 'active', role: 'EMPLOYEE', branch: 'Central Branch'),
    ];

    _branches = <BranchRecord>[
      BranchRecord(id: 'br_001', name: 'Downtown Branch', code: 'NB-DT-01', city: 'New York', manager: 'Helen Brooks', status: 'active'),
      BranchRecord(id: 'br_002', name: 'Westside Branch', code: 'NB-WS-02', city: 'Los Angeles', manager: 'Owen Carter', status: 'active'),
      BranchRecord(id: 'br_003', name: 'Central Branch', code: 'NB-CT-03', city: 'Chicago', manager: 'Aisha Noor', status: 'active'),
      BranchRecord(id: 'br_004', name: 'Harbor Branch', code: 'NB-HB-04', city: 'Miami', manager: 'Ravi Patel', status: 'active'),
    ];

    _approvals = <ApprovalItem>[
      ApprovalItem(id: 'apr_001', type: 'deposit', customerName: 'Maria Santos', amount: '1500.00', submittedAt: day(0), madeBy: 'usr_e_002', status: 'pending', description: 'Cash deposit at Downtown Branch'),
      ApprovalItem(id: 'apr_002', type: 'withdrawal', customerName: 'Daniel Kim', amount: '750.00', submittedAt: day(0), madeBy: 'usr_e_003', status: 'pending', description: 'Counter withdrawal'),
      ApprovalItem(id: 'apr_003', type: 'account', customerName: 'Sofia Rossi', amount: '0', submittedAt: day(1), madeBy: 'usr_e_002', status: 'pending', description: 'New current account request'),
      ApprovalItem(id: 'apr_004', type: 'loan', customerName: 'Noah Williams', amount: '9000.00', submittedAt: day(1), madeBy: 'usr_e_003', status: 'pending', description: 'Personal loan application'),
    ];

    _kyc = <KycRecord>[
      KycRecord(id: 'kyc_001', customerName: 'Emma Brown', documentType: 'Passport', submittedAt: day(1), status: 'pending'),
      KycRecord(id: 'kyc_002', customerName: 'Liam Chen', documentType: 'National ID', submittedAt: day(2), status: 'pending'),
      KycRecord(id: 'kyc_003', customerName: 'Olivia Davis', documentType: 'Driver licence', submittedAt: day(5), status: 'verified'),
    ];

    _audit = List<AuditEvent>.generate(18, (i) => AuditEvent(
          id: 'aud_${i + 1}',
          actor: i % 3 == 0 ? 'priya.shah@nexbank.demo' : i % 3 == 1 ? 'admin@nexbank.demo' : 'system',
          action: <String>['LOGIN', 'APPROVE_DEPOSIT', 'VIEW_CUSTOMER', 'EXPORT_REPORT', 'KYC_VERIFY', 'FAILED_LOGIN'][i % 6],
          target: i % 3 == 0 ? 'session' : 'cus_${(i % 9 + 1).toString().padLeft(3, '0')}',
          time: day(i).substring(0, 16),
          ip: '192.168.1.${20 + i}',
          risk: i % 6 == 5 ? 'medium' : 'low',
        ));
  }

  // ---- auth ----------------------------------------------------------------

  Future<UserModel> login(String email, String password) async {
    await _latency();
    final String normalized = email.trim().toLowerCase();
    if (_passwords[normalized] != password) {
      throw const AppException(
        message: 'Invalid email or password. Try demo@ or use Demo@123.',
        code: 'INVALID_CREDENTIALS',
        statusCode: 401,
      );
    }
    return _users.firstWhere((u) => u.email == normalized);
  }

  Future<String> issueToken(UserModel user) async {
    // Demo token is intentionally opaque and contains no real claims.
    return 'demo.${user.role.wireValue.toLowerCase()}.${user.id}.token';
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    await _latency();
    if (_users.any((u) => u.email == email.toLowerCase())) {
      throw const AppException(
        message: 'An account with this email already exists.',
        code: 'EMAIL_EXISTS',
        statusCode: 409,
      );
    }
    final UserModel user = UserModel(
      id: 'usr_c_${_users.length + 1}',
      name: name.trim(),
      email: email.trim().toLowerCase(),
      role: AppRole.customer,
      phone: phone,
      kycStatus: 'pending',
    );
    _users.add(user);
    _passwords[user.email] = password;
    _audit.insert(0, AuditEvent(id: 'aud_${_audit.length + 1}', actor: user.email, action: 'REGISTER', target: user.id, time: DateTime.now().toIso8601String(), ip: 'demo'));
    _pushNotification('Welcome to NEXBANK', 'Your account was created. Complete KYC to unlock all services.', 'system');
    return user;
  }

  Future<void> requestOtp(String email) async {
    await _latency();
    if (!_users.any((u) => u.email == email.trim().toLowerCase())) {
      throw const AppException(message: 'No account found for that email.', code: 'NOT_FOUND', statusCode: 404);
    }
    _otps[email.trim().toLowerCase()] = AppConstants.otpDemoCode;
  }

  Future<String> verifyOtp(String email, String code) async {
    await _latency();
    if (_otps[email.trim().toLowerCase()] != code.trim()) {
      throw const AppException(message: 'Incorrect verification code.', code: 'INVALID_OTP', statusCode: 400);
    }
    final String token = 'demo-reset-${_random.nextInt(999999)}';
    _resetTokens[token] = email.trim().toLowerCase();
    return token;
  }

  Future<void> resetPassword(String token, String newPassword) async {
    await _latency();
    final String? email = _resetTokens.remove(token);
    if (email == null) {
      throw const AppException(message: 'Reset link is invalid or expired.', code: 'INVALID_TOKEN', statusCode: 400);
    }
    _passwords[email] = newPassword;
  }

  Future<UserModel> currentUser(String userId) async {
    await _latency();
    return _users.firstWhere((u) => u.id == userId);
  }

  Future<void> changePassword(String userId, String oldPassword, String newPassword) async {
    await _latency();
    final UserModel user = _users.firstWhere((u) => u.id == userId);
    if (_passwords[user.email] != oldPassword) {
      throw const AppException(message: 'Current password is incorrect.', code: 'BAD_PASSWORD', statusCode: 400);
    }
    _passwords[user.email] = newPassword;
  }

  List<Map<String, dynamic>> loginHistory(String userId) => <Map<String, dynamic>>[
        <String, dynamic>{'device': 'Chrome on macOS', 'ip': '192.168.1.24', 'time': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(), 'current': true},
        <String, dynamic>{'device': 'NEXBANK Android', 'ip': '10.0.2.15', 'time': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(), 'current': false},
        <String, dynamic>{'device': 'Safari on iPhone', 'ip': '10.0.4.8', 'time': DateTime.now().subtract(const Duration(days: 9)).toIso8601String(), 'current': false},
      ];

  // ---- accounts & money ----------------------------------------------------

  Future<List<AccountModel>> accounts() async {
    await _latency();
    return List<AccountModel>.from(_accounts);
  }

  Future<AccountModel> account(String id) async {
    await _latency();
    return _accounts.firstWhere((a) => a.id == id);
  }

  Future<AccountModel> accountByNumber(String number) async {
    await _latency();
    return _accounts.firstWhere(
      (a) => a.accountNumber == number,
      orElse: () => throw const AppException(message: 'Recipient account not found.', code: 'NOT_FOUND', statusCode: 404),
    );
  }

  Future<AccountModel> requestAccount(String type, String name) async {
    await _latency();
    final AccountModel created = AccountModel(
      id: 'acc_${_accounts.length + 1}',
      accountNumber: '${1002003001 + _accounts.length}',
      name: name.trim().isEmpty ? '$type account' : name.trim(),
      type: type.toLowerCase(),
      balance: '0.00',
      currency: 'USD',
      status: 'pending',
      openedAt: DateTime.now().toIso8601String(),
    );
    _accounts.add(created);
    _approvals.insert(0, ApprovalItem(
      id: 'apr_${_approvals.length + 1}', type: 'account', customerName: 'Alex Morgan',
      amount: '0', submittedAt: DateTime.now().toIso8601String(),
      madeBy: 'usr_c_001', status: 'pending', description: 'New $type account request',
    ));
    _pushNotification('Account request submitted', 'Your new $type account is awaiting verification.', 'system');
    return created;
  }

  Future<CustomerStats> customerStats() async {
    await _latency();
    return CustomerStats(
      totalBalance: _sum(_accounts.map((a) => a.balance)),
      savings: (_accounts.where((a) => a.isSavings).fold<int>(0, (int p, AccountModel a) => p + _cents(a.balance)) / 100).toStringAsFixed(2),
      income: _sum(_transactions.where((t) => t.direction == 'credit').map((t) => t.amount)),
      expenses: _sum(_transactions.where((t) => t.direction == 'debit').map((t) => t.amount)),
      monthlyIncome: const <double>[2800, 3400, 3100, 4200, 3900, 4700],
      monthlyExpense: const <double>[1900, 2300, 2100, 2600, 2400, 2850],
      transactionCount: _transactions.length,
    );
  }

  Future<List<TransactionModel>> transactions({
    String? accountId,
    String? type,
    String? status,
    String? search,
    int? limit,
  }) async {
    await _latency();
    Iterable<TransactionModel> result = _transactions;
    if (accountId != null && accountId.isNotEmpty) {
      result = result.where((t) => t.accountId == accountId);
    }
    if (type != null && type.isNotEmpty && type != 'all') {
      result = result.where((t) => t.type == type);
    }
    if (status != null && status.isNotEmpty && status != 'all') {
      result = result.where((t) => t.status == status);
    }
    if (search != null && search.isNotEmpty) {
      final String q = search.toLowerCase();
      result = result.where((t) =>
          t.title.toLowerCase().contains(q) ||
          t.reference.toLowerCase().contains(q) ||
          t.counterparty.toLowerCase().contains(q));
    }
    final List<TransactionModel> list = result.toList()
      ..sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    return limit == null ? list : list.take(limit).toList();
  }

  Future<TransactionModel> transaction(String id) async {
    await _latency();
    return _transactions.firstWhere((t) => t.id == id || t.reference == id);
  }

  Future<TransactionModel> createDeposit({
    required String accountId,
    required String amount,
    required String note,
    required String idempotencyKey,
  }) async {
    await _latency();
    _checkIdempotency(idempotencyKey);
    final AccountModel target = await account(accountId);
    _validateAmount(amount);
    final TransactionModel txn = TransactionModel(
      id: 'txn_${_transactions.length + 1}',
      reference: _reference(), title: 'Cash deposit', type: 'deposit',
      amount: amount, direction: 'credit', status: 'pending',
      date: DateTime.now().toIso8601String(), accountId: target.id, note: note,
    );
    _transactions.insert(0, txn);
    _approvals.insert(0, ApprovalItem(id: 'apr_${_approvals.length + 1}', type: 'deposit', customerName: 'Alex Morgan', amount: amount, submittedAt: txn.date, madeBy: 'usr_e_002', status: 'pending', description: note));
    _audit.insert(0, AuditEvent(id: 'aud_${_audit.length + 1}', actor: 'customer@nexbank.demo', action: 'DEPOSIT_REQUEST', target: txn.reference, time: txn.date, ip: 'demo'));
    _pushNotification('Deposit submitted', 'Your deposit of ${Formatters.money(amount)} is pending approval.', 'transaction');
    return txn;
  }

  Future<TransactionModel> createWithdrawal({
    required String accountId,
    required String amount,
    required String note,
    required String idempotencyKey,
  }) async {
    await _latency();
    _checkIdempotency(idempotencyKey);
    final AccountModel source = await account(accountId);
    _validateAmount(amount);
    if (_cents(source.balance) < _cents(amount)) {
      throw const AppException(message: 'Insufficient available balance.', code: 'INSUFFICIENT_FUNDS', statusCode: 422);
    }
    if (_cents(amount) > 500000) {
      throw const AppException(message: 'Withdrawal exceeds the per-transaction limit of \$5,000.', code: 'LIMIT_EXCEEDED', statusCode: 422);
    }
    final TransactionModel txn = TransactionModel(
      id: 'txn_${_transactions.length + 1}', reference: _reference(),
      title: 'Cash withdrawal', type: 'withdrawal', amount: amount,
      direction: 'debit', status: 'pending', date: DateTime.now().toIso8601String(),
      accountId: source.id, note: note,
    );
    _transactions.insert(0, txn);
    _approvals.insert(0, ApprovalItem(id: 'apr_${_approvals.length + 1}', type: 'withdrawal', customerName: 'Alex Morgan', amount: amount, submittedAt: txn.date, madeBy: 'usr_e_002', status: 'pending', description: note));
    _pushNotification('Withdrawal submitted', 'Your withdrawal of ${Formatters.money(amount)} is pending approval.', 'transaction');
    return txn;
  }

  Future<TransactionModel> createTransfer({
    required String fromAccountId,
    required String toAccountNumber,
    required String amount,
    required String note,
    required String otp,
    required String idempotencyKey,
  }) async {
    await _latency();
    _checkIdempotency(idempotencyKey);
    if (otp.trim() != AppConstants.otpDemoCode) {
      throw const AppException(message: 'Incorrect OTP. Use 123456 in demo mode.', code: 'INVALID_OTP', statusCode: 400);
    }
    final AccountModel source = await account(fromAccountId);
    final AccountModel destination = await accountByNumber(toAccountNumber);
    if (source.id == destination.id) {
      throw const AppException(message: 'Choose a different destination account.', code: 'SAME_ACCOUNT', statusCode: 422);
    }
    _validateAmount(amount);
    if (_cents(source.balance) < _cents(amount)) {
      throw const AppException(message: 'Insufficient available balance.', code: 'INSUFFICIENT_FUNDS', statusCode: 422);
    }
    // Atomic in-memory debit + credit. In production this is a DB transaction.
    final int cents = _cents(amount);
    _accounts[_accounts.indexWhere((a) => a.id == source.id)] = source.copyWithBalance(
        ((_cents(source.balance) - cents) / 100).toStringAsFixed(2));
    _accounts[_accounts.indexWhere((a) => a.id == destination.id)] =
        destination.copyWithBalance(
            ((_cents(destination.balance) + cents) / 100).toStringAsFixed(2));
    final String now = DateTime.now().toIso8601String();
    final TransactionModel debit = TransactionModel(
      id: 'txn_${_transactions.length + 1}', reference: _reference(),
      title: 'Transfer to ${destination.name}', type: 'transfer', amount: amount,
      direction: 'debit', status: 'completed', date: now,
      accountId: source.id, counterparty: destination.accountNumber, note: note,
      category: 'Transfer',
    );
    _transactions.insert(0, debit);
    _pushNotification('Transfer complete', '${Formatters.money(amount)} was sent to ${destination.name}. Reference ${debit.reference}.', 'transaction');
    _audit.insert(0, AuditEvent(id: 'aud_${_audit.length + 1}', actor: 'customer@nexbank.demo', action: 'TRANSFER', target: debit.reference, time: now, ip: 'demo'));
    _persist();
    return debit;
  }

  Future<TransactionModel> createBillPayment({
    required String accountId,
    required String billerName,
    required String customerCode,
    required String amount,
    required String note,
  }) async {
    await _latency();
    final AccountModel source = await account(accountId);
    _validateAmount(amount);
    if (_cents(source.balance) < _cents(amount)) {
      throw const AppException(
        message: 'Insufficient available balance.',
        code: 'INSUFFICIENT_FUNDS',
        statusCode: 422,
      );
    }
    final int cents = _cents(amount);
    _accounts[_accounts.indexWhere((a) => a.id == source.id)] =
        source.copyWithBalance(
            ((_cents(source.balance) - cents) / 100).toStringAsFixed(2));
    final String now = DateTime.now().toIso8601String();
    final TransactionModel txn = TransactionModel(
      id: 'txn_${_transactions.length + 1}',
      reference: _reference(),
      title: 'Bill Pay — $billerName',
      type: 'card',
      amount: amount,
      direction: 'debit',
      status: 'completed',
      date: now,
      accountId: source.id,
      counterparty: customerCode,
      category: 'Bills',
      note: note.isNotEmpty ? note : 'Bill payment for $customerCode',
    );
    _transactions.insert(0, txn);
    _pushNotification(
      'Bill payment completed',
      '${Formatters.money(amount)} paid for $billerName ($customerCode). Ref: ${txn.reference}',
      'transaction',
    );
    _persist();
    return txn;
  }

  Future<TransactionModel> createMobileTopup({
    required String accountId,
    required String operatorName,
    required String mobileNumber,
    required String amount,
  }) async {
    await _latency();
    final AccountModel source = await account(accountId);
    _validateAmount(amount);
    if (_cents(source.balance) < _cents(amount)) {
      throw const AppException(
        message: 'Insufficient available balance.',
        code: 'INSUFFICIENT_FUNDS',
        statusCode: 422,
      );
    }
    final int cents = _cents(amount);
    _accounts[_accounts.indexWhere((a) => a.id == source.id)] =
        source.copyWithBalance(
            ((_cents(source.balance) - cents) / 100).toStringAsFixed(2));
    final String now = DateTime.now().toIso8601String();
    final TransactionModel txn = TransactionModel(
      id: 'txn_${_transactions.length + 1}',
      reference: _reference(),
      title: 'Top-up — $operatorName ($mobileNumber)',
      type: 'card',
      amount: amount,
      direction: 'debit',
      status: 'completed',
      date: now,
      accountId: source.id,
      counterparty: mobileNumber,
      category: 'Topup',
      note: 'Mobile recharge',
    );
    _transactions.insert(0, txn);
    _pushNotification(
      'Top-up successful',
      '${Formatters.money(amount)} top-up to $operatorName ($mobileNumber). Ref: ${txn.reference}',
      'transaction',
    );
    _persist();
    return txn;
  }

  Future<TransactionModel> createMfsTransfer({
    required String accountId,
    required String mfsProvider,
    required String recipientMobile,
    required String amount,
  }) async {
    await _latency();
    final AccountModel source = await account(accountId);
    _validateAmount(amount);
    if (_cents(source.balance) < _cents(amount)) {
      throw const AppException(
        message: 'Insufficient available balance.',
        code: 'INSUFFICIENT_FUNDS',
        statusCode: 422,
      );
    }
    final int cents = _cents(amount);
    _accounts[_accounts.indexWhere((a) => a.id == source.id)] =
        source.copyWithBalance(
            ((_cents(source.balance) - cents) / 100).toStringAsFixed(2));
    final String now = DateTime.now().toIso8601String();
    final TransactionModel txn = TransactionModel(
      id: 'txn_${_transactions.length + 1}',
      reference: _reference(),
      title: 'Transfer to $mfsProvider ($recipientMobile)',
      type: 'transfer',
      amount: amount,
      direction: 'debit',
      status: 'completed',
      date: now,
      accountId: source.id,
      counterparty: recipientMobile,
      category: 'MFS Transfer',
      note: '$mfsProvider cash-out',
    );
    _transactions.insert(0, txn);
    _pushNotification(
      'MFS Transfer complete',
      '${Formatters.money(amount)} transferred to $mfsProvider ($recipientMobile). Ref: ${txn.reference}',
      'transaction',
    );
    _persist();
    return txn;
  }

  Future<List<BeneficiaryModel>> beneficiaries() async {
    await _latency();
    return List<BeneficiaryModel>.from(_beneficiaries);
  }

  Future<BeneficiaryModel> addBeneficiary({
    required String name,
    required String accountNumber,
    required String bank,
    required String nickname,
  }) async {
    await _latency();
    final BeneficiaryModel b = BeneficiaryModel(
      id: 'ben_${_beneficiaries.length + 1}', name: name.trim(),
      accountNumber: accountNumber.trim(), bank: bank.trim().isEmpty ? 'NEXBANK' : bank.trim(),
      nickname: nickname.trim(),
    );
    _beneficiaries.add(b);
    return b;
  }

  Future<void> deleteBeneficiary(String id) async {
    await _latency();
    _beneficiaries.removeWhere((b) => b.id == id);
  }

  Future<List<LoanModel>> loans() async {
    await _latency();
    return List<LoanModel>.from(_loans);
  }

  Future<LoanModel> applyLoan({required String type, required String amount, required int termMonths}) async {
    await _latency();
    final LoanModel loan = LoanModel(
      id: 'loan_${_loans.length + 1}', type: type, amount: amount,
      outstanding: amount, status: 'pending', appliedAt: DateTime.now().toIso8601String(),
      termMonths: termMonths,
    );
    _loans.insert(0, loan);
    _pushNotification('Loan application received', 'Your $type application is under review.', 'system');
    return loan;
  }

  Future<TransactionModel> repayLoan(String loanId, String amount) async {
    await _latency();
    final LoanModel loan = _loans.firstWhere((l) => l.id == loanId);
    final double balance = double.parse(loan.outstanding) - double.parse(amount);
    _loans[_loans.indexWhere((l) => l.id == loanId)] = LoanModel(
      id: loan.id, type: loan.type, amount: loan.amount,
      outstanding: balance <= 0 ? '0.00' : balance.toStringAsFixed(2),
      status: balance <= 0 ? 'closed' : loan.status, appliedAt: loan.appliedAt,
      termMonths: loan.termMonths, interestRate: loan.interestRate, nextDueDate: loan.nextDueDate,
    );
    final TransactionModel txn = TransactionModel(
      id: 'txn_${_transactions.length + 1}', reference: _reference(),
      title: 'Loan repayment', type: 'loan', amount: amount, direction: 'debit',
      status: 'completed', date: DateTime.now().toIso8601String(), category: 'Loan',
    );
    _transactions.insert(0, txn);
    return txn;
  }

  Future<List<CardModel>> cards() async {
    await _latency();
    return List<CardModel>.from(_cards);
  }

  Future<CardModel> setCardStatus(String id, String status) async {
    await _latency();
    final int index = _cards.indexWhere((c) => c.id == id);
    _cards[index] = CardModel(
      id: _cards[index].id, type: _cards[index].type, last4: _cards[index].last4,
      holder: _cards[index].holder, expiry: _cards[index].expiry,
      status: status, limit: _cards[index].limit,
    );
    _pushNotification('Card ${status == 'blocked' ? 'blocked' : 'unblocked'}', 'Your card ending ${_cards[index].last4} was updated.', 'security');
    return _cards[index];
  }

  Future<List<SavingsGoalModel>> savingsGoals() async {
    await _latency();
    return List<SavingsGoalModel>.from(_goals);
  }

  Future<SavingsGoalModel> addSavingsGoal({required String name, required String target, required String deadline}) async {
    await _latency();
    final SavingsGoalModel goal = SavingsGoalModel(
      id: 'goal_${_goals.length + 1}', name: name, target: target, saved: '0', deadline: deadline,
    );
    _goals.add(goal);
    return goal;
  }

  Future<List<FixedDepositModel>> fixedDeposits() async {
    await _latency();
    return List<FixedDepositModel>.from(_fixedDeposits);
  }

  Future<FixedDepositModel> openFixedDeposit({required String amount, required int termMonths}) async {
    await _latency();
    final FixedDepositModel fd = FixedDepositModel(
      id: 'fd_${_fixedDeposits.length + 1}', amount: amount, termMonths: termMonths,
      rate: '6.50', status: 'active', startedAt: DateTime.now().toIso8601String(),
    );
    _fixedDeposits.add(fd);
    return fd;
  }

  // ---- notifications & profile ---------------------------------------------

  Future<List<NotificationModel>> notifications() async {
    await _latency();
    return List<NotificationModel>.from(_notifications);
  }

  Future<void> markNotificationRead(String id) async {
    await _latency();
    final int i = _notifications.indexWhere((n) => n.id == id);
    if (i >= 0) {
      _notifications[i] = NotificationModel(
        id: _notifications[i].id, title: _notifications[i].title,
        body: _notifications[i].body, time: _notifications[i].time,
        type: _notifications[i].type, isRead: true,
      );
    }
  }

  Future<void> markAllNotificationsRead() async {
    await _latency();
    _notifications = _notifications
        .map((n) => NotificationModel(id: n.id, title: n.title, body: n.body, time: n.time, type: n.type, isRead: true))
        .toList();
  }

  Future<UserModel> updateProfile(String id, {String? name, String? phone}) async {
    await _latency();
    final int i = _users.indexWhere((u) => u.id == id);
    _users[i] = _users[i].copyWith(name: name, phone: phone);
    return _users[i];
  }

  // ---- staff / admin --------------------------------------------------------

  Future<AdminStats> adminStats() async {
    await _latency();
    return AdminStats(
      totalCustomers: _customers.length + 1843,
      totalAccounts: _accounts.length + 3921,
      totalDeposits: '2847500.00',
      totalWithdrawals: '1192400.00',
      totalTransactions: 24891,
      totalLoans: 412,
      activeEmployees: _employees.length + 46,
      totalBranches: _branches.length + 18,
      pendingApprovals: _approvals.length,
      suspiciousTransactions: 7,
      depositSeries: const <double>[180, 220, 205, 290, 260, 340, 310, 390, 365, 420, 400, 470],
      withdrawalSeries: const <double>[120, 140, 118, 175, 160, 210, 190, 230, 215, 260, 240, 280],
      customerGrowth: const <double>[120, 145, 160, 178, 195, 220, 248, 270, 295, 318, 340, 365],
    );
  }

  Future<List<PersonRecord>> customers({String? search, String? status}) async {
    await _latency();
    return _filterPersons(_customers, search, status);
  }

  Future<List<PersonRecord>> employees({String? search, String? status}) async {
    await _latency();
    return _filterPersons(_employees, search, status);
  }

  Future<List<BranchRecord>> branches({String? search}) async {
    await _latency();
    if (search == null || search.isEmpty) return List<BranchRecord>.from(_branches);
    final String q = search.toLowerCase();
    return _branches.where((b) => b.name.toLowerCase().contains(q) || b.city.toLowerCase().contains(q)).toList();
  }

  Future<List<ApprovalItem>> approvals({String? type, String? status}) async {
    await _latency();
    return _approvals.where((a) =>
        (type == null || type.isEmpty || type == 'all' || a.type == type) &&
        (status == null || status.isEmpty || status == 'all' || a.status == status)).toList();
  }

  Future<void> approve(String approvalId, String checkerId) async {
    await _latency();
    final int i = _approvals.indexWhere((a) => a.id == approvalId);
    if (i < 0) throw const AppException(message: 'Approval not found.', code: 'NOT_FOUND', statusCode: 404);
    if (_approvals[i].madeBy == checkerId) {
      throw const AppException(
        message: 'Maker–checker rule: you cannot approve your own request.',
        code: 'SELF_APPROVAL', statusCode: 409,
      );
    }
    final ApprovalItem item = _approvals[i];
    _approvals[i] = ApprovalItem(id: item.id, type: item.type, customerName: item.customerName, amount: item.amount, submittedAt: item.submittedAt, madeBy: item.madeBy, status: 'approved', description: item.description);
    // In a real bank, the ledger posting happens atomically in the same
    // database transaction as the approval, server-side.
    _audit.insert(0, AuditEvent(id: 'aud_${_audit.length + 1}', actor: checkerId, action: 'APPROVE_${item.type.toUpperCase()}', target: item.id, time: DateTime.now().toIso8601String(), ip: 'demo'));
    _pushNotification('Request approved', '${item.type} request for ${item.customerName} was approved.', 'system');
  }

  Future<void> reject(String approvalId, String checkerId, String reason) async {
    await _latency();
    final int i = _approvals.indexWhere((a) => a.id == approvalId);
    if (i < 0) throw const AppException(message: 'Approval not found.', code: 'NOT_FOUND', statusCode: 404);
    if (_approvals[i].madeBy == checkerId) {
      throw const AppException(message: 'Maker–checker rule: you cannot reject your own request.', code: 'SELF_APPROVAL', statusCode: 409);
    }
    if (reason.trim().isEmpty) {
      throw const AppException(message: 'A rejection reason is required.', code: 'VALIDATION', statusCode: 422);
    }
    final ApprovalItem item = _approvals[i];
    _approvals[i] = ApprovalItem(id: item.id, type: item.type, customerName: item.customerName, amount: item.amount, submittedAt: item.submittedAt, madeBy: item.madeBy, status: 'rejected', description: '${item.description} — $reason');
    _audit.insert(0, AuditEvent(id: 'aud_${_audit.length + 1}', actor: checkerId, action: 'REJECT_${item.type.toUpperCase()}', target: item.id, time: DateTime.now().toIso8601String(), ip: 'demo'));
  }

  Future<List<KycRecord>> kycRecords({String? status}) async {
    await _latency();
    return _kyc.where((k) => status == null || status == 'all' || k.status == status).toList();
  }

  Future<void> reviewKyc(String id, String status, String reviewerId) async {
    await _latency();
    final int i = _kyc.indexWhere((k) => k.id == id);
    if (i < 0) return;
    _kyc[i] = KycRecord(id: _kyc[i].id, customerName: _kyc[i].customerName, documentType: _kyc[i].documentType, submittedAt: _kyc[i].submittedAt, status: status);
    _audit.insert(0, AuditEvent(id: 'aud_${_audit.length + 1}', actor: reviewerId, action: 'KYC_${status.toUpperCase()}', target: id, time: DateTime.now().toIso8601String(), ip: 'demo'));
  }

  Future<List<AuditEvent>> auditLogs({String? search}) async {
    await _latency();
    if (search == null || search.isEmpty) return List<AuditEvent>.from(_audit);
    final String q = search.toLowerCase();
    return _audit.where((a) => a.actor.toLowerCase().contains(q) || a.action.toLowerCase().contains(q)).toList();
  }

  Future<List<Map<String, dynamic>>> report(String type) async {
    await _latency();
    return <Map<String, dynamic>>[
      <String, dynamic>{'period': 'Jan', 'deposits': '180000', 'withdrawals': '120000', 'transactions': 1840},
      <String, dynamic>{'period': 'Feb', 'deposits': '220000', 'withdrawals': '140000', 'transactions': 2010},
      <String, dynamic>{'period': 'Mar', 'deposits': '205000', 'withdrawals': '118000', 'transactions': 1975},
      <String, dynamic>{'period': 'Apr', 'deposits': '290000', 'withdrawals': '175000', 'transactions': 2340},
    ];
  }

  Map<String, dynamic> settings() => <String, dynamic>{
        'institution': 'NEXBANK',
        'baseCurrency': 'USD',
        'sessionTimeoutMinutes': 15,
        'dailyTransferLimit': '10000.00',
        'maintenanceMode': false,
      };

  Future<void> saveSettings(Map<String, dynamic> values) async {
    await _latency();
    _audit.insert(0, AuditEvent(id: 'aud_${_audit.length + 1}', actor: 'admin@nexbank.demo', action: 'UPDATE_SETTINGS', target: 'system', time: DateTime.now().toIso8601String(), ip: 'demo'));
  }

  // ---- helpers --------------------------------------------------------------

  void _pushNotification(String title, String body, String type) {
    _notifications.insert(0, NotificationModel(
      id: 'ntf_${_notifications.length + 1}', title: title, body: body,
      time: DateTime.now().toIso8601String(), type: type,
    ));
    _persist();
  }

  void _persist() {
    try {
      final StorageService storage = StorageService.instance;
      storage.setString('demo.accounts', jsonEncode(_accounts.map((e) => e.toJson()).toList()));
      storage.setString('demo.transactions', jsonEncode(_transactions.map((e) => e.toJson()).toList()));
      storage.setString('demo.beneficiaries', jsonEncode(_beneficiaries.map((e) => e.toJson()).toList()));
      storage.setString('demo.loans', jsonEncode(_loans.map((e) => e.toJson()).toList()));
      storage.setString('demo.cards', jsonEncode(_cards.map((e) => e.toJson()).toList()));
      storage.setString('demo.notifications', jsonEncode(_notifications.map((e) => e.toJson()).toList()));
      storage.setString('demo.goals', jsonEncode(_goals.map((e) => e.toJson()).toList()));
      storage.setString('demo.fixed_deposits', jsonEncode(_fixedDeposits.map((e) => e.toJson()).toList()));
    } catch (_) {}
  }

  void _loadFromStorage() {
    try {
      final StorageService storage = StorageService.instance;
      final String? accStr = storage.getString('demo.accounts');
      if (accStr != null && accStr.isNotEmpty) {
        final List list = jsonDecode(accStr) as List;
        _accounts = list.map((e) => AccountModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      final String? txnStr = storage.getString('demo.transactions');
      if (txnStr != null && txnStr.isNotEmpty) {
        final List list = jsonDecode(txnStr) as List;
        _transactions = list.map((e) => TransactionModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      final String? benStr = storage.getString('demo.beneficiaries');
      if (benStr != null && benStr.isNotEmpty) {
        final List list = jsonDecode(benStr) as List;
        _beneficiaries = list.map((e) => BeneficiaryModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      final String? loanStr = storage.getString('demo.loans');
      if (loanStr != null && loanStr.isNotEmpty) {
        final List list = jsonDecode(loanStr) as List;
        _loans = list.map((e) => LoanModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      final String? cardStr = storage.getString('demo.cards');
      if (cardStr != null && cardStr.isNotEmpty) {
        final List list = jsonDecode(cardStr) as List;
        _cards = list.map((e) => CardModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      final String? ntfStr = storage.getString('demo.notifications');
      if (ntfStr != null && ntfStr.isNotEmpty) {
        final List list = jsonDecode(ntfStr) as List;
        _notifications = list.map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      final String? goalStr = storage.getString('demo.goals');
      if (goalStr != null && goalStr.isNotEmpty) {
        final List list = jsonDecode(goalStr) as List;
        _goals = list.map((e) => SavingsGoalModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      final String? fdStr = storage.getString('demo.fixed_deposits');
      if (fdStr != null && fdStr.isNotEmpty) {
        final List list = jsonDecode(fdStr) as List;
        _fixedDeposits = list.map((e) => FixedDepositModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
    } catch (_) {}
  }

  void _checkIdempotency(String key) {
    if (!_usedIdempotencyKeys.add(key)) {
      throw const AppException(message: 'Duplicate request detected. Please refresh.', code: 'DUPLICATE_REQUEST', statusCode: 409);
    }
  }

  void _validateAmount(String amount) {
    final num? value = num.tryParse(amount);
    if (value == null || value <= 0) {
      throw const AppException(message: 'Enter a valid amount.', code: 'VALIDATION', statusCode: 422);
    }
  }

  int _cents(String amount) => (double.tryParse(amount)! * 100).round();

  String _sum(Iterable<String> values) =>
      (values.fold<int>(0, (int p, String v) => p + _cents(v)) / 100).toStringAsFixed(2);

  String _reference() => 'NXB-${_random.nextInt(900000) + 100000}';

  List<PersonRecord> _filterPersons(List<PersonRecord> source, String? search, String? status) {
    Iterable<PersonRecord> result = source;
    if (status != null && status.isNotEmpty && status != 'all') {
      result = result.where((p) => p.status == status);
    }
    if (search != null && search.isNotEmpty) {
      final String q = search.toLowerCase();
      result = result.where((p) => p.name.toLowerCase().contains(q) || p.email.toLowerCase().contains(q) || p.id.toLowerCase().contains(q));
    }
    return result.toList();
  }
}

extension on AccountModel {
  AccountModel copyWithBalance(String value) => AccountModel(
        id: id, accountNumber: accountNumber, name: name, type: type,
        balance: value, currency: currency, status: status,
        openedAt: openedAt, branch: branch, interestRate: interestRate,
      );
}

