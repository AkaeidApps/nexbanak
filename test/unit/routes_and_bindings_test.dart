import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/bindings/app_bindings.dart';
import 'package:nexbanak/app/routes/app_pages.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/core/services/biometric_service.dart';
import 'package:nexbanak/core/services/receipt_service.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:nexbanak/data/repositories/auth_repository.dart';

const List<String> allRoutes = <String>[
  Routes.splash,
  Routes.onboarding,
  Routes.login,
  Routes.register,
  Routes.forgotPassword,
  Routes.otp,
  Routes.resetPassword,
  Routes.roleSelect,
  Routes.customerHome,
  Routes.customerAccounts,
  Routes.transfer,
  Routes.customerTransactions,
  Routes.customerProfile,
  Routes.adminHome,
  Routes.adminCustomers,
  Routes.adminAccounts,
  Routes.adminTransactions,
  Routes.adminMore,
  Routes.employeeHome,
  Routes.employeeCustomers,
  Routes.employeeOperations,
  Routes.approvals,
  Routes.employeeProfile,
  Routes.notifications,
  Routes.profile,
  Routes.security,
  Routes.loginHistory,
  Routes.settings,
  Routes.auditLogs,
  Routes.reports,
  Routes.branches,
  Routes.employees,
  Routes.kyc,
  Routes.loans,
  Routes.cards,
  Routes.savings,
  Routes.beneficiaries,
  Routes.deposit,
  Routes.withdrawal,
  Routes.accountDetail,
  Routes.transactionDetail,
  Routes.help,
];

void main() {
  tearDown(() => Get.reset());

  test('every declared route has a unique page entry', () {
    final List<String> names =
        AppPages.pages.map((GetPage<dynamic> page) => page.name).toList();

    for (final String route in allRoutes) {
      expect(names, contains(route), reason: 'Missing route $route');
    }
    expect(names.length, names.toSet().length, reason: 'Duplicate route names');
    for (final GetPage<dynamic> page in AppPages.pages) {
      expect(page.page, isNotNull, reason: 'Null builder for ${page.name}');
    }
  });

  test('role home routes are part of the deep-linkable table', () {
    final List<String> names =
        AppPages.pages.map((GetPage<dynamic> page) => page.name).toList();
    for (final AppRole role in AppRole.values) {
      expect(names, contains(role.homeRoute));
    }
  });

  test('AppBinding registers long-lived demo services', () {
    AppBinding().dependencies();

    expect(Get.isRegistered<AuthService>(), isTrue);
    expect(Get.isRegistered<BiometricService>(), isTrue);
    expect(Get.isRegistered<RepositoryProvider>(), isTrue);
    expect(Get.isRegistered<ReceiptService>(), isTrue);
    expect(Get.isPrepared<AuthController>(), isTrue);
  });

  test('RepositoryProvider selects in-memory demo repositories by default', () {
    final RepositoryProvider repos = RepositoryProvider();
    repos.onInit();

    expect(repos.demo, isNotNull);
    expect(repos.auth, isA<DemoAuthRepository>());
    expect(repos.banking, isNotNull);
    expect(repos.admin, isNotNull);
  });
}
