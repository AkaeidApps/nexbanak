import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService extends GetxService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> get isAvailable async {
    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate({
    String reason = 'Verify your identity to access NEXBANK',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
