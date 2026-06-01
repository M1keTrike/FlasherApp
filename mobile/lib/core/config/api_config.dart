/// Configuración central de la API.
///
/// La base URL apunta al dominio de producción desplegado en EC2 detrás de
/// nginx con SSL. Para desarrollo local puedes cambiarla temporalmente a
/// `http://10.0.2.2:3000` (emulador Android) o `http://localhost:3000`.
class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = 'https://flasherapi.alphahills.site';
}
