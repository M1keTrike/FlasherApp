import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  TokenStore(this._prefs) {
    _token = _prefs.getString(_key);
  }

  static const String _key = 'auth_token';

  final SharedPreferences _prefs;
  String? _token;

  String? get token => _token;
  bool get hasToken => _token != null && _token!.isNotEmpty;

  Future<void> save(String token) async {
    _token = token;
    await _prefs.setString(_key, token);
  }

  Future<void> clear() async {
    _token = null;
    await _prefs.remove(_key);
  }
}
