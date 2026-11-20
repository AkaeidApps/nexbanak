import 'package:nexbanak/data/models/user_model.dart';

class SessionResult {
  const SessionResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final UserModel user;
  final String accessToken;
  final String refreshToken;
}
