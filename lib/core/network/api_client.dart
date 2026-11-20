import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:nexbanak/app/constants/api_endpoints.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/core/errors/app_exception.dart';
import 'package:nexbanak/core/network/token_store.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/core/services/network_info.dart';
import 'package:nexbanak/core/utils/idempotency.dart';

/// Single Dio client for the whole app: auth headers, refresh-token rotation,
/// idempotency keys, connectivity checks, retry of safe GETs and one central
/// error type for all repositories.
class ApiClient extends GetxService {
  ApiClient({TokenStore? tokenStore, NetworkInfo? networkInfo})
      : _networkInfo = networkInfo ?? NetworkInfo() {
    _tokenStore = tokenStore;
  }

  TokenStore? _tokenStore;
  final NetworkInfo _networkInfo;
  late final Dio _dio;
  late final Dio _refreshDio;
  bool _refreshing = false;

  TokenStore get _tokens => _tokenStore ?? Get.find<AuthService>();

  static const Set<String> _publicPaths = <String>{
    ApiEndpoints.login,
    ApiEndpoints.register,
    ApiEndpoints.forgotPassword,
    ApiEndpoints.verifyOtp,
    ApiEndpoints.resetPassword,
  };

  static const Set<String> _financialPaths = <String>{
    ApiEndpoints.deposits,
    ApiEndpoints.withdrawals,
    ApiEndpoints.transfers,
    ApiEndpoints.loans,
  };

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeoutMs),
      headers: <String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Client': 'nexbank-flutter/${AppConstants.appVersion}',
      },
    ));
    _refreshDio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeoutMs),
      headers: <String, dynamic>{'Accept': 'application/json'},
    ));
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) =>
      _request(() => _dio.get<Map<String, dynamic>>(path, queryParameters: query));

  Future<Map<String, dynamic>> post(
    String path, {
    Object? data,
    bool idempotent = false,
  }) =>
      _request(
        () => _dio.post<Map<String, dynamic>>(
          path,
          data: data,
          options: idempotent || _financialPaths.contains(path)
              ? Options(headers: <String, dynamic>{
                  'Idempotency-Key': Idempotency.newKey(),
                })
              : null,
        ),
      );

  Future<Map<String, dynamic>> patch(String path, {Object? data}) =>
      _request(() => _dio.patch<Map<String, dynamic>>(path, data: data));

  Future<void> delete(String path) => _request(() => _dio.delete(path));

  Future<Map<String, dynamic>> _request(
    Future<Response<dynamic>> Function() send, {
    int attempt = 0,
  }) async {
    if (!await _networkInfo.isOnline) {
      throw const AppException(
        message: 'No internet connection. Check your network and retry.',
        code: 'NO_CONNECTION',
        isRetryable: true,
      );
    }
    try {
      _attachAuth();
      final Response<dynamic> response = await send();
      final Object? data = response.data;
      if (data is Map) return Map<String, dynamic>.from(data);
      if (data is List) return <String, dynamic>{'items': data};
      return <String, dynamic>{};
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 &&
          _tokens.refreshToken != null &&
          !_publicPaths.contains(e.requestOptions.path)) {
        final bool refreshed = await _refreshTokens();
        if (refreshed) return _request(send, attempt: attempt);
      }
      final AppException error = AppException.fromDio(e);
      if (error.isRetryable && attempt < 2 && e.requestOptions.method == 'GET') {
        await Future<void>.delayed(Duration(milliseconds: 300 * (attempt + 1)));
        return _request(send, attempt: attempt + 1);
      }
      throw error;
    }
  }

  void _attachAuth() {
    final String? token = _tokens.accessToken;
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  Future<bool> _refreshTokens() async {
    if (_refreshing) return false;
    _refreshing = true;
    try {
      final Response<dynamic> response = await _refreshDio.post<dynamic>(
        ApiEndpoints.refresh,
        data: <String, dynamic>{'refreshToken': _tokens.refreshToken},
      );
      final Map<String, dynamic> body = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final String? access = (body['accessToken'] ?? body['token'])?.toString();
      if (access == null) return false;
      await _tokens.saveTokens(
        access: access,
        refresh: (body['refreshToken'] ?? _tokens.refreshToken).toString(),
      );
      return true;
    } catch (_) {
      return false;
    } finally {
      _refreshing = false;
    }
  }
}
