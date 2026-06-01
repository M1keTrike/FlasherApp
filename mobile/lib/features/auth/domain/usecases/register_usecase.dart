import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: registrar un nuevo usuario.
class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthResult> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.register(name: name, email: email, password: password);
  }
}
