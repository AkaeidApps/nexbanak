import 'package:get/get.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/core/network/api_client.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/core/services/biometric_service.dart';
import 'package:nexbanak/core/services/receipt_service.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/features/accounts/controllers/accounts_controller.dart';
import 'package:nexbanak/features/admin/controllers/admin_home_controller.dart';
import 'package:nexbanak/features/admin/controllers/admin_operations_controller.dart';
import 'package:nexbanak/features/admin/controllers/admin_records_controller.dart';
import 'package:nexbanak/features/admin/controllers/approvals_controller.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:nexbanak/features/customer/controllers/customer_home_controller.dart';
import 'package:nexbanak/features/customer/controllers/money_controller.dart';
import 'package:nexbanak/features/customer/controllers/services_controller.dart';
import 'package:nexbanak/features/employee/controllers/employee_controller.dart';
import 'package:nexbanak/features/notifications/controllers/notifications_controller.dart';
import 'package:nexbanak/features/profile/controllers/profile_controller.dart';
import 'package:nexbanak/features/settings/controllers/system_controller.dart';
import 'package:nexbanak/features/transactions/controllers/transactions_controller.dart';

/// Registers long-lived services once for the whole app. [AuthService] is
/// created and initialized in `main()` so restored sessions are available
/// before the first route builds.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthService>()) Get.put(AuthService(), permanent: true);
    if (!Get.isRegistered<BiometricService>()) {
      Get.put(BiometricService(), permanent: true);
    }
    if (!AppConstants.useMock && !Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(), permanent: true);
    }
    if (!Get.isRegistered<RepositoryProvider>()) {
      Get.put(RepositoryProvider(), permanent: true);
    }
    if (!Get.isRegistered<ReceiptService>()) {
      Get.put(ReceiptService(), permanent: true);
    }
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(
        () => AuthController(Get.find(), Get.find(), Get.find()),
      );
    }
    if (!Get.isRegistered<NotificationsController>()) {
      Get.lazyPut<NotificationsController>(() => NotificationsController());
    }
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    if (!Get.isRegistered<ApprovalsController>()) {
      Get.lazyPut<ApprovalsController>(() => ApprovalsController());
    }
    if (!Get.isRegistered<SystemController>()) {
      Get.lazyPut<SystemController>(() => SystemController());
    }
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(Get.find(), Get.find(), Get.find()),
    );
  }
}

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerHomeController>(() => CustomerHomeController());
    Get.lazyPut<AccountsController>(() => AccountsController());
    Get.lazyPut<MoneyController>(() => MoneyController());
    Get.lazyPut<ServicesController>(() => ServicesController());
    Get.lazyPut<TransactionsController>(() => TransactionsController());
  }
}

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminHomeController>(() => AdminHomeController());
    Get.lazyPut<AdminOperationsController>(() => AdminOperationsController());
    Get.lazyPut<AdminRecordsController>(() => AdminRecordsController('customers'), tag: 'customers');
    Get.lazyPut<AdminRecordsController>(() => AdminRecordsController('employees'), tag: 'employees');
    Get.lazyPut<AdminRecordsController>(() => AdminRecordsController('branches'), tag: 'branches');
    Get.lazyPut<AdminRecordsController>(() => AdminRecordsController('kyc'), tag: 'kyc');
  }
}

class EmployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeController>(() => EmployeeController());
  }
}

class SharedBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotificationsController>()) {
      Get.lazyPut<NotificationsController>(() => NotificationsController());
    }
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    if (!Get.isRegistered<ApprovalsController>()) {
      Get.lazyPut<ApprovalsController>(() => ApprovalsController());
    }
    if (!Get.isRegistered<SystemController>()) {
      Get.lazyPut<SystemController>(() => SystemController());
    }
  }
}
