class PersonRecord {
  const PersonRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    this.role = 'CUSTOMER',
    this.branch = 'Downtown Branch',
    this.kyc = 'verified',
    this.joinedAt = '',
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String status;
  final String role;
  final String branch;
  final String kyc;
  final String joinedAt;

  factory PersonRecord.fromJson(Map<String, dynamic> json) => PersonRecord(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        phone: (json['phone'] ?? '').toString(),
        status: (json['status'] ?? 'active').toString(),
        role: (json['role'] ?? 'CUSTOMER').toString(),
        branch: (json['branch'] ?? 'Downtown Branch').toString(),
        kyc: (json['kyc'] ?? 'verified').toString(),
        joinedAt: (json['joinedAt'] ?? '').toString(),
      );
}

class BranchRecord {
  const BranchRecord({
    required this.id,
    required this.name,
    required this.code,
    required this.city,
    required this.manager,
    required this.status,
  });

  final String id;
  final String name;
  final String code;
  final String city;
  final String manager;
  final String status;

  factory BranchRecord.fromJson(Map<String, dynamic> json) => BranchRecord(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? 'Branch').toString(),
        code: (json['code'] ?? '').toString(),
        city: (json['city'] ?? '').toString(),
        manager: (json['manager'] ?? '').toString(),
        status: (json['status'] ?? 'active').toString(),
      );
}

class ApprovalItem {
  const ApprovalItem({
    required this.id,
    required this.type,
    required this.customerName,
    required this.amount,
    required this.submittedAt,
    required this.madeBy,
    required this.status,
    this.description = '',
  });

  final String id;
  final String type;
  final String customerName;
  final String amount;
  final String submittedAt;
  final String madeBy;
  final String status;
  final String description;

  factory ApprovalItem.fromJson(Map<String, dynamic> json) => ApprovalItem(
        id: (json['id'] ?? '').toString(),
        type: (json['type'] ?? 'deposit').toString(),
        customerName: (json['customerName'] ?? '').toString(),
        amount: (json['amount'] ?? '0').toString(),
        submittedAt: (json['submittedAt'] ?? '').toString(),
        madeBy: (json['madeBy'] ?? json['makerId'] ?? '').toString(),
        status: (json['status'] ?? 'pending').toString(),
        description: (json['description'] ?? '').toString(),
      );
}

class AuditEvent {
  const AuditEvent({
    required this.id,
    required this.actor,
    required this.action,
    required this.target,
    required this.time,
    required this.ip,
    this.risk = 'low',
  });

  final String id;
  final String actor;
  final String action;
  final String target;
  final String time;
  final String ip;
  final String risk;

  factory AuditEvent.fromJson(Map<String, dynamic> json) => AuditEvent(
        id: (json['id'] ?? '').toString(),
        actor: (json['actor'] ?? 'system').toString(),
        action: (json['action'] ?? '').toString(),
        target: (json['target'] ?? '').toString(),
        time: (json['time'] ?? json['createdAt'] ?? '').toString(),
        ip: (json['ip'] ?? '—').toString(),
        risk: (json['risk'] ?? 'low').toString(),
      );
}

class KycRecord {
  const KycRecord({
    required this.id,
    required this.customerName,
    required this.documentType,
    required this.submittedAt,
    required this.status,
  });

  final String id;
  final String customerName;
  final String documentType;
  final String submittedAt;
  final String status;

  factory KycRecord.fromJson(Map<String, dynamic> json) => KycRecord(
        id: (json['id'] ?? '').toString(),
        customerName: (json['customerName'] ?? '').toString(),
        documentType: (json['documentType'] ?? 'National ID').toString(),
        submittedAt: (json['submittedAt'] ?? '').toString(),
        status: (json['status'] ?? 'pending').toString(),
      );
}
