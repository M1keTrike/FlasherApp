import 'user.dart';

/// Resultado de un login/registro: el usuario y su token de acceso.
class AuthResult {
  const AuthResult({required this.user, required this.accessToken});

  final User user;
  final String accessToken;
}
