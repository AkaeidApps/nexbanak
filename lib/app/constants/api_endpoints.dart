/// REST paths mirroring docs/API_CONTRACT.md.
class ApiEndpoints {
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String refresh = '$auth/refresh';
  static const String logout = '$auth/logout';
  static const String forgotPassword = '$auth/forgot-password';
  static const String verifyOtp = '$auth/verify-otp';
  static const String resetPassword = '$auth/reset-password';
  static const String me = '$auth/me';
  static const String loginHistory = '$auth/login-history';
  static const String biometricVerify = '$auth/biometric/verify';

  static const String accounts = '/accounts';
  static const String accountRequests = '/accounts/requests';
  static const String deposits = '/deposits';
  static const String withdrawals = '/withdrawals';
  static const String transfers = '/transfers';
  static const String transactions = '/transactions';
  static const String beneficiaries = '/beneficiaries';
  static const String loans = '/loans';
  static const String cards = '/cards';
  static const String notifications = '/notifications';
  static const String customers = '/customers';
  static const String employees = '/employees';
  static const String branches = '/branches';
  static const String approvals = '/approvals';
  static const String kyc = '/kyc';
  static const String reports = '/reports';
  static const String auditLogs = '/audit-logs';
  static const String settings = '/settings';
  static const String security = '/security';
  static const String savingsGoals = '/savings-goals';
  static const String fixedDeposits = '/fixed-deposits';
}
