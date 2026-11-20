import 'dart:convert';

import 'package:get/get.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/core/network/token_store.dart';
import 'package:nexbanak/core/services/storage_service.dart';
import 'package:nexbanak/data/models/user_model.dart';

/// Owns the authenticated session. Stores only opaque tokens in secure
/// storage; the user object is in-memory and cleared with the session.
class AuthService extends GetxService implements TokenStore {
  final Rxn<UserModel> _user = Rxn<UserModel>();
  final RxnString _accessToken = RxnString();
  final RxnString _refreshToken = RxnString();
  final Rx<DateTime?> _expiry = Rx<DateTime?>(null);
  final RxnString _userId = RxnString();
  final RxBool _biometricEnabled = false.obs;

  UserModel? get user => _user.value;
  AppRole? get role => _user.value?.role;
  bool get isLoggedIn => _accessToken.value != null && user != null;
  @override
  String? get accessToken => _accessToken.value;
  @override
  String? get refreshToken => _refreshToken.value;
  bool get biometricEnabled => _biometricEnabled.value;
  DateTime? get expiry => _expiry.value;
  String? get userId => _userId.value;

  bool get isTokenExpired {
    final DateTime? exp = _expiry.value;
    return exp == null || DateTime.now().isAfter(exp);
  }

  Future<void> init() async {
    await StorageService.instance.init();
    _accessToken.value = await StorageService.instance
        .readSecure(StorageService.accessTokenKey);
    _refreshToken.value = await StorageService.instance
        .readSecure(StorageService.refreshTokenKey);
    _userId.value = StorageService.instance.getString('session.user_id');
    _biometricEnabled.value =
        StorageService.instance.getBool(StorageService.biometricKey);
    final String? exp = await StorageService.instance
        .readSecure(StorageService.sessionExpiryKey);
    if (exp != null) _expiry.value = DateTime.tryParse(exp);
  }

  Future<void> saveSession({
    required String access,
    required String refresh,
    required UserModel user,
  }) async {
    _accessToken.value = access;
    _refreshToken.value = refresh;
    _user.value = user;
    _expiry.value = _jwtExpiry(access);
    _userId.value = user.id;
    await StorageService.instance.setString('session.user_id', user.id);
    await Future.wait(<Future<void>>[
      StorageService.instance
          .writeSecure(StorageService.accessTokenKey, access),
      StorageService.instance
          .writeSecure(StorageService.refreshTokenKey, refresh),
      if (_expiry.value != null)
        StorageService.instance.writeSecure(
          StorageService.sessionExpiryKey,
          _expiry.value!.toIso8601String(),
        ),
    ]);
  }

  @override
  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    _accessToken.value = access;
    _refreshToken.value = refresh;
    _expiry.value = _jwtExpiry(access);
    await Future.wait(<Future<void>>[
      StorageService.instance
          .writeSecure(StorageService.accessTokenKey, access),
      StorageService.instance
          .writeSecure(StorageService.refreshTokenKey, refresh),
    ]);
  }

  @override
  Future<void> clearTokens() async {
    _accessToken.value = null;
    _refreshToken.value = null;
    _expiry.value = null;
    await StorageService.instance.clearSecureSession();
  }

  Future<void> signOut() async {
    _user.value = null;
    _userId.value = null;
    await StorageService.instance.remove('session.user_id');
    await clearTokens();
  }

  void updateUser(UserModel user) => _user.value = user;

  Future<void> setBiometric(bool enabled) async {
    _biometricEnabled.value = enabled;
    await StorageService.instance
        .setBool(StorageService.biometricKey, enabled);
  }

  bool hasRole(AppRole role) => this.role == role;

  bool can(String permission) => role?.can(permission) ?? false;

  void requireRole(AppRole requiredRole) {
    if (!hasRole(requiredRole)) {
      throw StateError('Access denied: ${requiredRole.label} role required');
    }
  }

  static DateTime? _jwtExpiry(String token) {
    try {
      final List<String> parts = token.split('.');
      if (parts.length < 2) return null;
      final String payload = parts[1];
      final String normalized = payload.padRight(
        payload.length + (4 - payload.length % 4) % 4,
        '=',
      );
      final Map<String, dynamic> decoded =
          jsonDecode(utf8.decode(base64Url.decode(normalized))) as Map<String, dynamic>;
      final num? exp = decoded['exp'] as num?;
      return exp == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000);
    } catch (_) {
      return null;
    }
  }
}
