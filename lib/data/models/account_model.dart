class AccountModel {
  const AccountModel({
    required this.id,
    required this.accountNumber,
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    required this.status,
    required this.openedAt,
    this.branch = 'Downtown Branch',
    this.interestRate,
  });

  final String id;
  final String accountNumber;
  final String name;
  final String type; // savings | current
  final String balance; // authoritative decimal string from backend
  final String currency;
  final String status; // active | pending | frozen | closed
  final String openedAt;
  final String branch;
  final String? interestRate;

  bool get isActive => status.toLowerCase() == 'active';
  bool get isSavings => type.toLowerCase() == 'savings';

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        id: (json['id'] ?? '').toString(),
        accountNumber: (json['accountNumber'] ?? json['number'] ?? '').toString(),
        name: (json['name'] ?? json['accountName'] ?? 'Account').toString(),
        type: (json['type'] ?? 'savings').toString(),
        balance: (json['balance'] ?? '0').toString(),
        currency: (json['currency'] ?? 'USD').toString(),
        status: (json['status'] ?? 'active').toString(),
        openedAt: (json['openedAt'] ?? json['createdAt'] ?? '').toString(),
        branch: (json['branch'] ?? 'Downtown Branch').toString(),
        interestRate: json['interestRate']?.toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'accountNumber': accountNumber,
        'name': name,
        'type': type,
        'balance': balance,
        'currency': currency,
        'status': status,
        'openedAt': openedAt,
        'branch': branch,
        'interestRate': interestRate,
      };
}
