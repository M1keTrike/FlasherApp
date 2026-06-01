import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Resultado crudo de la API de autenticación (token + usuario).
class AuthDto {
  AuthDto({required this.accessToken, required this.user});

  final String accessToken;
  final UserModel user;
}

/// Fuente de datos remota: realiza las llamadas HTTP a /auth/*.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthDto> login(String email, String password) async {
    final json = await _apiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });
    return _parse(json);
  }

  Future<AuthDto> register(String name, String email, String password) async {
    final json = await _apiClient.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });
    return _parse(json);
  }

  AuthDto _parse(dynamic json) {
    return AuthDto(
      accessToken: json['accessToken'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
