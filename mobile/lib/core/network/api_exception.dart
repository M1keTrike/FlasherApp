/// Excepción de dominio para errores de red/API.
///
/// El [ApiClient] la lanza traduciendo los status codes a mensajes amigables
/// que la capa de presentación puede mostrar directamente (snackbars).
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
