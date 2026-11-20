/// Roles are duplicated on the server. These checks only shape the UX — the
/// backend must independently authorize every protected request (see
/// docs/API_CONTRACT.md) and enforce maker–checker separation.
enum AppRole {
  customer('CUSTOMER', 'Customer', '/customer/home'),
  employee('EMPLOYEE', 'Employee', '/employee/home'),
  admin('ADMIN', 'Admin', '/admin/home');

  const AppRole(this.wireValue, this.label, this.homeRoute);

  final String wireValue;
  final String label;
  final String homeRoute;

  static AppRole fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'ADMIN':
        return AppRole.admin;
      case 'EMPLOYEE':
      case 'STAFF':
        return AppRole.employee;
      default:
        return AppRole.customer;
    }
  }

  bool get isCustomer => this == AppRole.customer;
  bool get isEmployee => this == AppRole.employee;
  bool get isAdmin => this == AppRole.admin;
  bool get isStaff => isEmployee || isAdmin;

  bool can(String permission) => permissions.contains(permission);

  Set<String> get permissions => switch (this) {
        AppRole.customer => const {
            'account.read.own',
            'transaction.read.own',
            'deposit.create',
            'withdrawal.create',
            'transfer.create',
            'beneficiary.manage',
            'loan.apply',
            'card.manage.own',
            'profile.manage.own',
          },
        AppRole.employee => const {
            'customer.read',
            'account.read',
            'deposit.process',
            'withdrawal.process',
            'transfer.read',
            'transaction.read',
            'loan.review',
            'kyc.review',
            'approval.create',
            'approval.approve',
            'profile.manage.own',
          },
        AppRole.admin => const {
            'customer.manage',
            'employee.manage',
            'account.manage',
            'branch.manage',
            'deposit.manage',
            'withdrawal.manage',
            'transfer.manage',
            'transaction.manage',
            'loan.manage',
            'card.manage',
            'kyc.review',
            'report.read',
            'audit.read',
            'notification.manage',
            'settings.manage',
            'approval.approve',
            'profile.manage.own',
          },
      };
}
