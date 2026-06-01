import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exception.dart';
import 'token_store.dart';

class ApiClient {
  ApiClient(this._tokenStore, {http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;
  final TokenStore _tokenStore;

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_tokenStore.hasToken) {
      headers['Authorization'] = 'Bearer ${_tokenStore.token}';
    }
    return headers;
  }

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<dynamic> get(String path) async {
    final response = await _send(
      () => _client.get(_uri(path), headers: _headers),
    );
    return _decode(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await _send(
      () => _client.post(_uri(path), headers: _headers, body: jsonEncode(body)),
    );
    return _decode(response);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final response = await _send(
      () => _client.put(_uri(path), headers: _headers, body: jsonEncode(body)),
    );
    return _decode(response);
  }

  Future<void> delete(String path) async {
    final response = await _send(
      () => _client.delete(_uri(path), headers: _headers),
    );
    _ensureSuccess(response);
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request();
    } on Exception {
      throw ApiException(
        'No se pudo conectar con el servidor. Revisa tu conexión.',
      );
    }
  }

  void _ensureSuccess(http.Response response) {
    final code = response.statusCode;
    if (code >= 200 && code < 300) return;

    String message;
    switch (code) {
      case 400:
        message = _serverMessage(response) ?? 'Datos inválidos.';
        break;
      case 401:
        message = 'Credenciales inválidas o sesión expirada.';
        break;
      case 404:
        message = 'El recurso solicitado no existe.';
        break;
      case 409:
        message = _serverMessage(response) ?? 'El recurso ya existe.';
        break;
      case 500:
        message = 'Error interno del servidor. Inténtalo más tarde.';
        break;
      default:
        message = _serverMessage(response) ?? 'Ocurrió un error inesperado.';
    }
    throw ApiException(message, statusCode: code);
  }

  dynamic _decode(http.Response response) {
    _ensureSuccess(response);
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }

  String? _serverMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['message'] != null) {
        final msg = decoded['message'];
        return msg is List ? msg.join(', ') : msg.toString();
      }
    } catch (_) {}
    return null;
  }
}
