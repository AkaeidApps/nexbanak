class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.reference,
    required this.title,
    required this.type,
    required this.amount,
    required this.direction,
    required this.status,
    required this.date,
    this.accountId = '',
    this.counterparty = '',
    this.category = 'Other',
    this.note = '',
  });

  final String id;
  final String reference;
  final String title;
  final String type; // deposit | withdrawal | transfer | loan | card
  final String amount;
  final String direction; // credit | debit
  final String status; // pending | completed | rejected | failed
  final String date;
  final String accountId;
  final String counterparty;
  final String category;
  final String note;

  bool get isCredit => direction == 'credit';
  bool get isCompleted => status.toLowerCase() == 'completed';

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: (json['id'] ?? '').toString(),
        reference: (json['reference'] ?? json['ref'] ?? '').toString(),
        title: (json['title'] ?? json['description'] ?? 'Transaction').toString(),
        type: (json['type'] ?? 'transfer').toString(),
        amount: (json['amount'] ?? '0').toString(),
        direction: (json['direction'] ?? (json['type'] == 'deposit' ? 'credit' : 'debit'))
            .toString(),
        status: (json['status'] ?? 'completed').toString(),
        date: (json['date'] ?? json['createdAt'] ?? '').toString(),
        accountId: (json['accountId'] ?? '').toString(),
        counterparty: (json['counterparty'] ?? '').toString(),
        category: (json['category'] ?? 'Other').toString(),
        note: (json['note'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'reference': reference,
        'title': title,
        'type': type,
        'amount': amount,
        'direction': direction,
        'status': status,
        'date': date,
        'accountId': accountId,
        'counterparty': counterparty,
        'category': category,
        'note': note,
      };
}
