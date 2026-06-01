import 'package:flutter/foundation.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/token_store.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required TokenStore tokenStore,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _tokenStore = tokenStore;

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final TokenStore _tokenStore;

  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _tokenStore.hasToken;

  Future<bool> login({required String email, required String password}) {
    return _run(() => _loginUseCase(email: email, password: password));
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _run(
      () => _registerUseCase(name: name, email: email, password: password),
    );
  }

  Future<void> logout() async {
    await _tokenStore.clear();
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> _run(Future<dynamic> Function() action) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final result = await action();
      await _tokenStore.save(result.accessToken as String);
      _currentUser = result.user as User;
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = 'Ocurrió un error inesperado.';
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
  }
}
