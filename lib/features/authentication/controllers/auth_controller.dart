import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/core/services/biometric_service.dart';
import 'package:nexbanak/core/services/storage_service.dart';
import 'package:nexbanak/core/utils/validators.dart';
import 'package:nexbanak/data/models/session_result.dart';
import 'package:nexbanak/data/providers/demo_data_source.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';

class AuthController extends BaseController {
  AuthController(this._auth, this._repositories, this._biometric);

  final AuthService _auth;
  final RepositoryProvider _repositories;
  final BiometricService _biometric;

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxString name = ''.obs;
  final RxString phone = ''.obs;
  final RxString otp = ''.obs;
  final RxString newPassword = ''.obs;
  final RxString resetToken = ''.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool rememberMe = false.obs;
  final RxBool biometricAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRememberedEmail();
    _checkBiometric();
  }

  Future<void> _loadRememberedEmail() async {
    await StorageService.instance.init();
    final String? saved =
        StorageService.instance.getString(StorageService.rememberEmailKey);
    if (saved != null) {
      email.value = saved;
      rememberMe.value = true;
    }
  }

  Future<void> _checkBiometric() async {
    biometricAvailable.value = await _biometric.isAvailable && _auth.biometricEnabled;
  }

  String? validateEmail(String? value) => Validators.email(value);
  String? validatePassword(String? value) => Validators.password(value);

  Future<void> login() async {
    final String? emailError = validateEmail(email.value);
    if (emailError != null) return showError(emailError);
    if (password.value.isEmpty) return showError('Password is required');

    final SessionResult? session = await guard(
      () => _repositories.auth.login(
        email: email.value.trim(),
        password: password.value,
      ),
    );
    if (session == null) return;
    await _finishSession(session);
  }

  /// One-tap demo sign-in for each role. Only available with USE_MOCK=true.
  Future<void> demoLogin(AppRole role) async {
    final String mail = switch (role) {
      AppRole.customer => DemoDataSource.demoCustomerEmail,
      AppRole.employee => DemoDataSource.demoEmployeeEmail,
      AppRole.admin => DemoDataSource.demoAdminEmail,
    };
    email.value = mail;
    password.value = DemoDataSource.demoPassword;
    await login();
  }

  Future<void> biometricLogin() async {
    final bool ok = await _biometric.authenticate();
    if (!ok) return showError('Biometric verification was not completed.');
    final String? cachedEmail =
        StorageService.instance.getString(StorageService.rememberEmailKey);
    if (cachedEmail == null) {
      return showError('Sign in with your password once to enable biometrics.');
    }
    email.value = cachedEmail;
    // Demo mode only: real apps exchange a biometric assertion server-side.
    final SessionResult? session = await guard(
      () => _repositories.auth.login(
        email: cachedEmail,
        password: DemoDataSource.demoPassword,
      ),
    );
    if (session != null) await _finishSession(session);
  }

  Future<void> register() async {
    final String? mailError = validateEmail(email.value);
    if (mailError != null) return showError(mailError);
    final String? passError = validatePassword(password.value);
    if (passError != null) return showError(passError);
    final String? nameError = Validators.required(name.value, 'Full name');
    if (nameError != null) return showError(nameError);
    final String? phoneError = Validators.phone(phone.value);
    if (phoneError != null) return showError(phoneError);

    final SessionResult? session = await guard(
      () => _repositories.auth.register(
        name: name.value,
        email: email.value,
        password: password.value,
        phone: phone.value,
      ),
      successMessage: 'Account created. Please complete KYC verification.',
    );
    if (session != null) await _finishSession(session);
  }

  Future<void> forgotPassword() async {
    final String? error = validateEmail(email.value);
    if (error != null) return showError(error);
    final bool ok = await guard(
      () async {
        await _repositories.auth.requestOtp(email.value.trim());
        return true;
      },
      successMessage: 'A verification code was sent to your email.',
    ) ?? false;
    if (ok) Get.toNamed(Routes.otp);
  }

  Future<void> verifyOtp() async {
    final String? error = Validators.otp(otp.value);
    if (error != null) return showError(error);
    final String? token = await guard(
      () => _repositories.auth.verifyOtp(
        email: email.value.trim(),
        code: otp.value,
      ),
    );
    if (token == null) return;
    resetToken.value = token;
    Get.toNamed(Routes.resetPassword);
  }

  Future<void> resetPassword() async {
    final String? error = validatePassword(newPassword.value);
    if (error != null) return showError(error);
    final bool ok = await guard(
      () async {
        await _repositories.auth.resetPassword(
          token: resetToken.value,
          newPassword: newPassword.value,
        );
        return true;
      },
      successMessage: 'Password updated. You can now sign in.',
    ) ?? false;
    if (ok) Get.offAllNamed(Routes.login);
  }

  Future<void> signOut() async {
    await guard(() async {
      await _repositories.auth.logout();
      await _auth.signOut();
      return true;
    }, silent: true);
    Get.offAllNamed(Routes.login);
  }

  Future<void> _finishSession(SessionResult session) async {
    await _auth.saveSession(
      access: session.accessToken,
      refresh: session.refreshToken,
      user: session.user,
    );
    if (rememberMe.value) {
      await StorageService.instance
          .setString(StorageService.rememberEmailKey, email.value.trim());
    }
    Get.offAllNamed(session.user.role.homeRoute);
  }
}

