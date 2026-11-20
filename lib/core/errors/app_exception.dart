import 'package:dio/dio.dart';

class AppException implements Exception {
  const AppException({
    required this.message,
    this.code = 'UNKNOWN',
    this.statusCode,
    this.isRetryable = false,
  });

  final String message;
  final String code;
  final int? statusCode;
  final bool isRetryable;

  @override
  String toString() => 'AppException($code, $statusCode): $message';

  factory AppException.fromDio(DioException e) {
    final int? status = e.response?.statusCode;
    final Object? data = e.response?.data;
    String? serverMessage;
    String? serverCode;
    if (data is Map) {
      final Object? error = data['error'];
      if (error is Map) {
        serverMessage = error['message']?.toString();
        serverCode = error['code']?.toString();
      }
      serverMessage ??= data['message']?.toString();
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(
          message: 'The request timed out. Please try again.',
          code: 'TIMEOUT',
          statusCode: status,
          isRetryable: true,
        );
      case DioExceptionType.connectionError:
        return AppException(
          message: 'No internet connection. Check your network and retry.',
          code: 'NO_CONNECTION',
          isRetryable: true,
        );
      case DioExceptionType.badCertificate:
        return const AppException(
          message: 'Secure connection could not be verified.',
          code: 'BAD_CERTIFICATE',
        );
      default:
        return AppException(
          message: serverMessage ?? _defaultMessage(status),
          code: serverCode ?? _defaultCode(status),
          statusCode: status,
          isRetryable: status != null && status >= 500,
        );
    }
  }

  static String _defaultMessage(int? status) => switch (status) {
        400 => 'Please check the details you entered.',
        401 => 'Your session has expired. Please sign in again.',
        403 => 'You do not have permission to perform this action.',
        404 => 'The requested record was not found.',
        409 => 'This request was already processed or conflicts with another.',
        422 => 'Validation failed. Please review your input.',
        429 => 'Too many attempts. Please wait and try again.',
        500 || 502 || 503 || 504 => 'Banking service is temporarily unavailable.',
        _ => 'Something went wrong. Please try again.',
      };

  static String _defaultCode(int? status) => switch (status) {
        400 => 'BAD_REQUEST',
        401 => 'UNAUTHENTICATED',
        403 => 'FORBIDDEN',
        404 => 'NOT_FOUND',
        409 => 'CONFLICT',
        422 => 'VALIDATION',
        429 => 'RATE_LIMITED',
        _ => 'UNKNOWN',
      };
}
