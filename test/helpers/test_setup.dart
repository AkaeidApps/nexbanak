import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/core/services/biometric_service.dart';
import 'package:nexbanak/core/services/storage_service.dart';
import 'package:nexbanak/data/models/user_model.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory stand-ins for platform channels so widget tests never touch real
/// keystores or preferences. Banking data itself is the labelled demo simulator.
final Map<String, String> secureStore = <String, String>{};

Future<void> initTestEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
    (MethodCall call) async {
      final Map<dynamic, dynamic> args =
          (call.arguments as Map?) ?? <dynamic, dynamic>{};
      final String key = args['key']?.toString() ?? '';
      switch (call.method) {
        case 'read':
          return secureStore[key];
        case 'containsKey':
          return secureStore.containsKey(key);
        case 'readAll':
          return Map<String, String>.from(secureStore);
        case 'write':
          secureStore[key] = args['value']?.toString() ?? '';
          return null;
        case 'delete':
          secureStore.remove(key);
          return null;
        case 'deleteAll':
          secureStore.clear();
          return null;
        case 'isProtectedDataAvailable':
          return true;
        default:
          return null;
      }
    },
  );

  await StorageService.instance.init();
  secureStore.clear();
  await Future.wait<void>(<Future<void>>[
    StorageService.instance.remove(StorageService.onboardingKey),
    StorageService.instance.remove(StorageService.themeKey),
    StorageService.instance.remove(StorageService.balanceHiddenKey),
    StorageService.instance.remove(StorageService.biometricKey),
    StorageService.instance.remove(StorageService.rememberEmailKey),
    StorageService.instance.remove('session.user_id'),
  ]);
  Get.reset();
}

UserModel testUser(AppRole role) => UserModel(
      id: role == AppRole.admin
          ? 'usr_a_001'
          : role == AppRole.employee
              ? 'usr_e_001'
              : 'usr_c_001',
      name: role == AppRole.admin
          ? 'Jordan Lee'
          : role == AppRole.employee
              ? 'Priya Shah'
              : 'Alex Morgan',
      email: role == AppRole.admin
          ? 'admin@nexbank.demo'
          : role == AppRole.employee
              ? 'employee@nexbank.demo'
              : 'customer@nexbank.demo',
      role: role,
      phone: '+1 555 0101',
    );

/// Registers the same long-lived services as [AppBinding] for demo mode.
Future<AuthService> registerCoreServices({
  AppRole role = AppRole.customer,
}) async {
  final AuthService auth = AuthService();
  Get.put<AuthService>(auth, permanent: true);
  auth.updateUser(testUser(role));

  if (!Get.isRegistered<RepositoryProvider>()) {
    Get.put<RepositoryProvider>(RepositoryProvider(), permanent: true);
  }
  if (!Get.isRegistered<BiometricService>()) {
    Get.put<BiometricService>(BiometricService(), permanent: true);
  }
  return auth;
}

/// Auth controller used by widget tests: skips platform lookups in `onInit`
/// while keeping the real sign-out and navigation behaviour under test.
class TestAuthController extends AuthController {
  TestAuthController()
      : super(
          Get.find<AuthService>(),
          Get.find<RepositoryProvider>(),
          Get.find<BiometricService>(),
        );

  @override
  // Intentionally skips AuthController.onInit: widget tests preload the
  // platform mocks and do not need remembered-email or biometric lookups.
  // ignore: must_call_super
  void onInit() {}
}
