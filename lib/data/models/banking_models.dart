class BeneficiaryModel {
  const BeneficiaryModel({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.bank,
    this.nickname = '',
    this.verified = true,
  });

  final String id;
  final String name;
  final String accountNumber;
  final String bank;
  final String nickname;
  final bool verified;

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) => BeneficiaryModel(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        accountNumber: (json['accountNumber'] ?? '').toString(),
        bank: (json['bank'] ?? 'NEXBANK').toString(),
        nickname: (json['nickname'] ?? '').toString(),
        verified: json['verified'] != false,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'accountNumber': accountNumber,
        'bank': bank,
        'nickname': nickname,
        'verified': verified,
      };
}

class LoanModel {
  const LoanModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.outstanding,
    required this.status,
    required this.appliedAt,
    this.termMonths = 12,
    this.interestRate = '8.5',
    this.nextDueDate = '',
  });

  final String id;
  final String type;
  final String amount;
  final String outstanding;
  final String status;
  final String appliedAt;
  final int termMonths;
  final String interestRate;
  final String nextDueDate;

  factory LoanModel.fromJson(Map<String, dynamic> json) => LoanModel(
        id: (json['id'] ?? '').toString(),
        type: (json['type'] ?? 'Personal loan').toString(),
        amount: (json['amount'] ?? '0').toString(),
        outstanding: (json['outstanding'] ?? '0').toString(),
        status: (json['status'] ?? 'active').toString(),
        appliedAt: (json['appliedAt'] ?? '').toString(),
        termMonths: int.tryParse(json['termMonths']?.toString() ?? '') ?? 12,
        interestRate: (json['interestRate'] ?? '8.5').toString(),
        nextDueDate: (json['nextDueDate'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'amount': amount,
        'outstanding': outstanding,
        'status': status,
        'appliedAt': appliedAt,
        'termMonths': termMonths,
        'interestRate': interestRate,
        'nextDueDate': nextDueDate,
      };
}

class CardModel {
  const CardModel({
    required this.id,
    required this.type,
    required this.last4,
    required this.holder,
    required this.expiry,
    required this.status,
    this.limit = '5000',
  });

  final String id;
  final String type; // debit | credit
  final String last4;
  final String holder;
  final String expiry;
  final String status; // active | blocked
  final String limit;

  bool get isBlocked => status.toLowerCase() == 'blocked';

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        id: (json['id'] ?? '').toString(),
        type: (json['type'] ?? 'debit').toString(),
        last4: (json['last4'] ?? '0000').toString(),
        holder: (json['holder'] ?? '').toString(),
        expiry: (json['expiry'] ?? '').toString(),
        status: (json['status'] ?? 'active').toString(),
        limit: (json['limit'] ?? '5000').toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'last4': last4,
        'holder': holder,
        'expiry': expiry,
        'status': status,
        'limit': limit,
      };
}

class SavingsGoalModel {
  const SavingsGoalModel({
    required this.id,
    required this.name,
    required this.target,
    required this.saved,
    required this.deadline,
  });

  final String id;
  final String name;
  final String target;
  final String saved;
  final String deadline;

  double get progress {
    final double t = double.tryParse(target) ?? 0;
    final double s = double.tryParse(saved) ?? 0;
    return t == 0 ? 0 : (s / t).clamp(0.0, 1.0);
  }

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) => SavingsGoalModel(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? 'Goal').toString(),
        target: (json['target'] ?? '0').toString(),
        saved: (json['saved'] ?? '0').toString(),
        deadline: (json['deadline'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'target': target,
        'saved': saved,
        'deadline': deadline,
      };
}

class FixedDepositModel {
  const FixedDepositModel({
    required this.id,
    required this.amount,
    required this.termMonths,
    required this.rate,
    required this.status,
    required this.startedAt,
  });

  final String id;
  final String amount;
  final int termMonths;
  final String rate;
  final String status;
  final String startedAt;

  factory FixedDepositModel.fromJson(Map<String, dynamic> json) => FixedDepositModel(
        id: (json['id'] ?? '').toString(),
        amount: (json['amount'] ?? '0').toString(),
        termMonths: int.tryParse(json['termMonths']?.toString() ?? '') ?? 12,
        rate: (json['rate'] ?? '6.5').toString(),
        status: (json['status'] ?? 'active').toString(),
        startedAt: (json['startedAt'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'amount': amount,
        'termMonths': termMonths,
        'rate': rate,
        'status': status,
        'startedAt': startedAt,
      };
}
