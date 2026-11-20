import 'package:get/get.dart';
import 'package:nexbanak/app/bindings/app_bindings.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/features/accounts/views/account_detail_view.dart';
import 'package:nexbanak/features/admin/views/admin_customers_view.dart';
import 'package:nexbanak/features/admin/views/admin_more_view.dart';
import 'package:nexbanak/features/admin/views/admin_operations_views.dart';
import 'package:nexbanak/features/admin/views/admin_shell.dart';
import 'package:nexbanak/features/admin/views/records_list_view.dart';
import 'package:nexbanak/features/authentication/views/login_view.dart';
import 'package:nexbanak/features/authentication/views/password_recovery_views.dart';
import 'package:nexbanak/features/authentication/views/register_view.dart';
import 'package:nexbanak/features/customer/views/customer_accounts_view.dart';
import 'package:nexbanak/features/customer/views/customer_profile_view.dart';
import 'package:nexbanak/features/customer/views/customer_shell.dart';
import 'package:nexbanak/features/customer/views/customer_transactions_view.dart';
import 'package:nexbanak/features/customer/views/money_views.dart';
import 'package:nexbanak/features/customer/views/services_views.dart';
import 'package:nexbanak/features/customer/views/transfer_view.dart';
import 'package:nexbanak/features/employee/views/approvals_view.dart';
import 'package:nexbanak/features/employee/views/employee_customers_view.dart';
import 'package:nexbanak/features/employee/views/employee_operations_view.dart';
import 'package:nexbanak/features/employee/views/employee_profile_view.dart';
import 'package:nexbanak/features/employee/views/employee_shell.dart';
import 'package:nexbanak/features/notifications/views/notifications_view.dart';
import 'package:nexbanak/features/onboarding/onboarding_view.dart';
import 'package:nexbanak/features/profile/views/profile_view.dart';
import 'package:nexbanak/features/profile/views/security_views.dart';
import 'package:nexbanak/features/reports/views/audit_logs_view.dart';
import 'package:nexbanak/features/reports/views/reports_view.dart';
import 'package:nexbanak/features/settings/views/settings_view.dart';
import 'package:nexbanak/features/splash/splash_view.dart';
import 'package:nexbanak/features/transactions/views/transaction_detail_view.dart';

/// Single source of truth for named navigation. Every route is reachable via
/// deep link, but [AuthService] + backend RBAC still decide what a user may see.
abstract class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage(name: Routes.splash, page: () => const SplashView()),
    GetPage(name: Routes.onboarding, page: () => const OnboardingView()),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.roleSelect,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.otp,
      page: () => const OtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => const ResetPasswordView(),
      binding: AuthBinding(),
    ),

    // Customer workspace
    GetPage(
      name: Routes.customerHome,
      page: () => const CustomerShell(),
      bindings: <Bindings>[CustomerBinding(), SharedBinding()],
    ),
    GetPage(
      name: Routes.customerAccounts,
      page: () => const CustomerAccountsView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.transfer,
      page: () => const TransferView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.customerTransactions,
      page: () => const CustomerTransactionsView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.customerProfile,
      page: () => const CustomerProfileView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.deposit,
      page: () => const DepositView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.withdrawal,
      page: () => const WithdrawalView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.beneficiaries,
      page: () => const BeneficiariesView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.loans,
      page: () => const LoansView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.cards,
      page: () => const CardsView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.savings,
      page: () => const SavingsView(),
      binding: CustomerBinding(),
    ),

    // Admin workspace
    GetPage(
      name: Routes.adminHome,
      page: () => const AdminShell(),
      bindings: <Bindings>[AdminBinding(), SharedBinding()],
    ),
    GetPage(
      name: Routes.adminCustomers,
      page: () => const AdminCustomersView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: Routes.adminAccounts,
      page: () => const AdminAccountsView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: Routes.adminTransactions,
      page: () => const AdminTransactionsView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: Routes.adminMore,
      page: () => const AdminMoreView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: Routes.employees,
      page: () => const RecordsListView(
        tag: 'employees',
        title: 'Employee management',
        emptyHint: 'No employees match your filters',
      ),
      binding: AdminBinding(),
    ),
    GetPage(
      name: Routes.branches,
      page: () => const RecordsListView(
        tag: 'branches',
        title: 'Branch management',
        emptyHint: 'No branches found',
      ),
      binding: AdminBinding(),
    ),
    GetPage(
      name: Routes.kyc,
      page: () => const RecordsListView(
        tag: 'kyc',
        title: 'KYC verification',
        emptyHint: 'No KYC submissions pending',
      ),
      binding: AdminBinding(),
    ),

    // Employee workspace
    GetPage(
      name: Routes.employeeHome,
      page: () => const EmployeeShell(),
      bindings: <Bindings>[EmployeeBinding(), SharedBinding()],
    ),
    GetPage(
      name: Routes.employeeCustomers,
      page: () => const EmployeeCustomersView(),
      binding: EmployeeBinding(),
    ),
    GetPage(
      name: Routes.employeeOperations,
      page: () => const EmployeeOperationsView(),
      binding: EmployeeBinding(),
    ),
    GetPage(
      name: Routes.employeeProfile,
      page: () => const EmployeeProfileView(),
      binding: SharedBinding(),
    ),
    GetPage(
      name: Routes.approvals,
      page: () => const ApprovalsView(),
      binding: SharedBinding(),
    ),

    // Shared detail and system screens
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsView(),
      binding: SharedBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: SharedBinding(),
    ),
    GetPage(
      name: Routes.security,
      page: () => const SecurityView(),
      binding: SharedBinding(),
    ),
    GetPage(
      name: Routes.loginHistory,
      page: () => const LoginHistoryView(),
      binding: SharedBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SharedBinding(),
    ),
    GetPage(
      name: Routes.auditLogs,
      page: () => const AuditLogsView(),
      binding: SharedBinding(),
    ),
    GetPage(
      name: Routes.reports,
      page: () => const ReportsView(),
      binding: SharedBinding(),
    ),
    GetPage(
      name: Routes.accountDetail,
      page: () => const AccountDetailView(),
    ),
    GetPage(
      name: Routes.transactionDetail,
      page: () => const TransactionDetailView(),
    ),
    GetPage(
      name: Routes.help,
      page: () => const HelpView(),
    ),
  ];
}
