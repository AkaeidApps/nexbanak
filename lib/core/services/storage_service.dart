import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sensitive credentials go only to platform keystores. Preferences hold
/// non-sensitive UI settings. Passwords are never persisted anywhere.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late final FlutterSecureStorage _secure;
  late final SharedPreferences _prefs;
  bool _ready = false;

  static const String accessTokenKey = 'nexbank.access_token';
  static const String refreshTokenKey = 'nexbank.refresh_token';
  static const String deviceIdKey = 'nexbank.device_id';
  static const String pinKey = 'nexbank.pin_hash';

  static const String onboardingKey = 'ui.onboarding_complete';
  static const String themeKey = 'ui.theme'; // system | light | dark
  static const String balanceHiddenKey = 'ui.balance_hidden';
  static const String biometricKey = 'ui.biometric_enabled';
  static const String rememberEmailKey = 'ui.remember_email';
  static const String sessionExpiryKey = 'session.expiry';

  Future<void> init() async {
    if (_ready) return;
    _secure = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    _prefs = await SharedPreferences.getInstance();
    _ready = true;
  }

  Future<String?> readSecure(String key) async =>
      _secure.read(key: key);

  Future<void> writeSecure(String key, String value) async =>
      _secure.write(key: key, value: value);

  Future<void> deleteSecure(String key) async => _secure.delete(key: key);

  Future<void> clearSecureSession() async {
    await Future.wait(<Future<void>>[
      _secure.delete(key: accessTokenKey),
      _secure.delete(key: refreshTokenKey),
      _secure.delete(key: sessionExpiryKey),
    ]);
  }

  String? getString(String key) => _prefs.getString(key);
  bool getBool(String key, [bool fallback = false]) =>
      _prefs.getBool(key) ?? fallback;

  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);
  Future<void> remove(String key) => _prefs.remove(key);
}
