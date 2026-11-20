import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/core/services/biometric_service.dart';
import 'package:nexbanak/core/utils/validators.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';

class ProfileController extends BaseController {
  final RxString name = ''.obs;
  final RxString phone = ''.obs;
  final RxString oldPassword = ''.obs;
  final RxString newPassword = ''.obs;
  final RxList<Map<String, dynamic>> loginHistory = <Map<String, dynamic>>[].obs;
  final RxBool biometric = false.obs;
  final RxBool biometricSupported = false.obs;

  @override
  void onInit() {
    super.onInit();
    final AuthService auth = Get.find<AuthService>();
    name.value = auth.user?.name ?? '';
    phone.value = auth.user?.phone ?? '';
    biometric.value = auth.biometricEnabled;
    _checkBiometric();
    loadLoginHistory();
  }

  Future<void> _checkBiometric() async {
    biometricSupported.value = await Get.find<BiometricService>().isAvailable;
  }

  Future<void> loadLoginHistory() => guard(() async {
        final AuthService auth = Get.find<AuthService>();
        if (auth.user == null) return true;
        loginHistory.assignAll(
          await Get.find<RepositoryProvider>().auth.loginHistory(auth.user!.id),
        );
        return true;
      }, silent: true);

  Future<void> saveProfile() => guard(() async {
        final AuthService auth = Get.find<AuthService>();
        if (auth.user == null) return true;
        final updated = await Get.find<RepositoryProvider>().banking.updateProfile(
              auth.user!.id,
              name: name.value,
              phone: phone.value,
            );
        auth.updateUser(updated);
        return true;
      }, successMessage: 'Profile updated.');

  Future<void> changePassword() => guard(() async {
        final String? error = Validators.password(newPassword.value);
        if (error != null) throw StateError(error);
        final AuthService auth = Get.find<AuthService>();
        if (auth.user == null) return true;
        await Get.find<RepositoryProvider>().auth.changePassword(
              userId: auth.user!.id,
              oldPassword: oldPassword.value,
              newPassword: newPassword.value,
            );
        oldPassword.value = '';
        newPassword.value = '';
        return true;
      }, successMessage: 'Password changed successfully.');

  Future<void> setBiometric(bool value) async {
    if (value) {
      final bool ok = await Get.find<BiometricService>()
          .authenticate(reason: 'Enable biometric sign-in for NEXBANK');
      if (!ok) return showError('Biometric verification failed.');
    }
    await Get.find<AuthService>().setBiometric(value);
    biometric.value = value;
    showSuccess(value ? 'Biometric sign-in enabled.' : 'Biometric sign-in disabled.');
  }

  void openSecurity() => Get.toNamed(Routes.security);
  void openLoginHistory() => Get.toNamed(Routes.loginHistory);
}
