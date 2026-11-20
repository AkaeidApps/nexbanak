import 'package:nexbanak/core/domain/app_role.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone = '',
    this.avatarUrl,
    this.branch = 'Downtown Branch',
    this.kycStatus = 'verified',
    this.customerId,
    this.employeeId,
  });

  final String id;
  final String name;
  final String email;
  final AppRole role;
  final String phone;
  final String? avatarUrl;
  final String branch;
  final String kycStatus;
  final String? customerId;
  final String? employeeId;

  bool get isCustomer => role.isCustomer;
  bool get isAdmin => role.isAdmin;
  bool get isEmployee => role.isEmployee;
  bool get isStaff => role.isStaff;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> user = (json['user'] is Map)
        ? Map<String, dynamic>.from(json['user'] as Map)
        : json;
    return UserModel(
      id: (user['id'] ?? user['userId'] ?? '').toString(),
      name: (user['name'] ?? user['fullName'] ?? 'NEXBANK User').toString(),
      email: (user['email'] ?? '').toString(),
      role: AppRole.fromString(user['role']?.toString()),
      phone: (user['phone'] ?? '').toString(),
      avatarUrl: user['avatarUrl']?.toString(),
      branch: (user['branch'] ?? 'Downtown Branch').toString(),
      kycStatus: (user['kycStatus'] ?? 'verified').toString(),
      customerId: user['customerId']?.toString(),
      employeeId: user['employeeId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'role': role.wireValue,
        'phone': phone,
        'branch': branch,
        'kycStatus': kycStatus,
        'customerId': customerId,
        'employeeId': employeeId,
      };

  UserModel copyWith({String? name, String? phone, String? avatarUrl}) => UserModel(
        id: id,
        name: name ?? this.name,
        email: email,
        role: role,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        branch: branch,
        kycStatus: kycStatus,
        customerId: customerId,
        employeeId: employeeId,
      );
}
