import 'user.dart';

class AuthResult {
  const AuthResult({required this.user, required this.accessToken});

  final User user;
  final String accessToken;
}
