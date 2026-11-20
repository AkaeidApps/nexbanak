/// Abstraction so the Dio layer never depends on a concrete service (and can
/// be replaced with a fake in tests).
abstract class TokenStore {
  String? get accessToken;
  String? get refreshToken;
  Future<void> saveTokens({required String access, required String refresh});
  Future<void> clearTokens();
}
