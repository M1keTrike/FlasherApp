import '../entities/auth_result.dart';

/// Contrato abstracto del repositorio de autenticación.
///
/// La capa `domain` define la interfaz; la capa `data` la implementa. Así el
/// dominio no depende de detalles de red (inversión de dependencias).
abstract class AuthRepository {
  Future<AuthResult> login({required String email, required String password});

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  });
}
