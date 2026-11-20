import 'package:nexbanak/app/constants/api_endpoints.dart';
import 'package:nexbanak/core/network/api_client.dart';
import 'package:nexbanak/core/services/storage_service.dart';
import 'package:nexbanak/data/models/session_result.dart';
import 'package:nexbanak/data/models/user_model.dart';
import 'package:nexbanak/data/providers/demo_data_source.dart';
import 'package:nexbanak/data/repositories/repository_helpers.dart';

abstract class AuthRepository {
  Future<SessionResult> login({required String email, required String password});
  Future<SessionResult> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
  Future<void> requestOtp(String email);
  Future<String> verifyOtp({required String email, required String code});
  Future<void> resetPassword({required String token, required String newPassword});
  Future<UserModel> currentUser(String userId);
  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });
  Future<List<Map<String, dynamic>>> loginHistory(String userId);
  Future<void> logout();
}

class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository(this._api);

  final ApiClient _api;

  SessionResult _session(Map<String, dynamic> body) => SessionResult(
        user: UserModel.fromJson(body),
        accessToken: (body['accessToken'] ?? body['token'] ?? '').toString(),
        refreshToken: (body['refreshToken'] ?? '').toString(),
      );

  @override
  Future<SessionResult> login({required String email, required String password}) async {
    final Map<String, dynamic> body = await _api.post(
      ApiEndpoints.login,
      data: <String, dynamic>{'email': email, 'password': password},
    );
    return _session(body);
  }

  @override
  Future<SessionResult> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final Map<String, dynamic> body = await _api.post(
      ApiEndpoints.register,
      data: <String, dynamic>{
        'name': name, 'email': email, 'password': password, 'phone': phone,
      },
    );
    return _session(body);
  }

  @override
  Future<void> requestOtp(String email) async {
    await _api.post(ApiEndpoints.forgotPassword, data: <String, dynamic>{'email': email});
  }

  @override
  Future<String> verifyOtp({required String email, required String code}) async {
    final Map<String, dynamic> body = await _api.post(
      ApiEndpoints.verifyOtp,
      data: <String, dynamic>{'email': email, 'code': code},
    );
    return (body['resetToken'] ?? body['token'] ?? '').toString();
  }

  @override
  Future<void> resetPassword({required String token, required String newPassword}) async {
    await _api.post(
      ApiEndpoints.resetPassword,
      data: <String, dynamic>{'token': token, 'password': newPassword},
    );
  }

  @override
  Future<UserModel> currentUser(String userId) async =>
      UserModel.fromJson(await _api.get(ApiEndpoints.me));

  @override
  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    await _api.post(
      '${ApiEndpoints.security}/password',
      data: <String, dynamic>{
        'currentPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
  }

  @override
  Future<List<Map<String, dynamic>>> loginHistory(String userId) async {
    final Map<String, dynamic> body = await _api.get(ApiEndpoints.loginHistory);
    return extractList(body, 'sessions');
  }

  @override
  Future<void> logout() async {
    try {
      await _api.post(ApiEndpoints.logout);
    } catch (_) {
      // Local sign-out must always succeed even if the network does not.
    }
    await StorageService.instance.remove(StorageService.rememberEmailKey);
  }
}

class DemoAuthRepository implements AuthRepository {
  DemoAuthRepository(this._demo);

  final DemoDataSource _demo;

  Future<SessionResult> _session(Future<UserModel> userFuture) async {
    final UserModel user = await userFuture;
    return SessionResult(
      user: user,
      accessToken: await _demo.issueToken(user),
      refreshToken: 'demo-refresh-${user.id}',
    );
  }

  @override
  Future<SessionResult> login({required String email, required String password}) =>
      _session(_demo.login(email, password));

  @override
  Future<SessionResult> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) =>
      _session(
        _demo.register(name: name, email: email, password: password, phone: phone),
      );

  @override
  Future<void> requestOtp(String email) => _demo.requestOtp(email);

  @override
  Future<String> verifyOtp({required String email, required String code}) =>
      _demo.verifyOtp(email, code);

  @override
  Future<void> resetPassword({required String token, required String newPassword}) =>
      _demo.resetPassword(token, newPassword);

  @override
  Future<UserModel> currentUser(String userId) => _demo.currentUser(userId);

  @override
  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) =>
      _demo.changePassword(userId, oldPassword, newPassword);

  @override
  Future<List<Map<String, dynamic>>> loginHistory(String userId) async =>
      _demo.loginHistory(userId);

  @override
  Future<void> logout() async {}
}
