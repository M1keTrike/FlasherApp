import '../../domain/entities/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementación del contrato [AuthRepository] usando la fuente remota.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final dto = await _remote.login(email, password);
    return AuthResult(user: dto.user, accessToken: dto.accessToken);
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final dto = await _remote.register(name, email, password);
    return AuthResult(user: dto.user, accessToken: dto.accessToken);
  }
}
