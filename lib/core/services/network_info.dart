import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  NetworkInfo({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> get isOnline async {
    try {
      final List<ConnectivityResult> results =
          await _connectivity.checkConnectivity();
      return results.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      // Connectivity plugins are unavailable on some desktop/web targets —
      // do not block a request because of that.
      return true;
    }
  }
}
