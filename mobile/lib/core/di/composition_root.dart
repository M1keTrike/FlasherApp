import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../network/token_store.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';

import '../../features/flashcards/data/datasources/flashcards_remote_datasource.dart';
import '../../features/flashcards/data/repositories/flashcard_repository_impl.dart';
import '../../features/flashcards/domain/repositories/flashcard_repository.dart';
import '../../features/flashcards/domain/usecases/create_flashcard_usecase.dart';
import '../../features/flashcards/domain/usecases/delete_flashcard_usecase.dart';
import '../../features/flashcards/domain/usecases/get_flashcards_usecase.dart';
import '../../features/flashcards/domain/usecases/update_flashcard_usecase.dart';
import '../../features/flashcards/presentation/viewmodels/flashcards_viewmodel.dart';

/// Composition Root: inyección de dependencias MANUAL (sin get_it ni similares).
///
/// Arma las dependencias a mano y en orden —
/// `datasource → repository → usecases → viewmodel` — y las expone como una
/// lista de providers para `MultiProvider` en `main.dart`.
class CompositionRoot {
  CompositionRoot(this._prefs) {
    _build();
  }

  final SharedPreferences _prefs;

  late final TokenStore _tokenStore;
  late final ApiClient _apiClient;

  // Auth
  late final AuthRepository _authRepository;
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;

  // Flashcards
  late final FlashcardRepository _flashcardRepository;
  late final GetFlashcardsUseCase _getFlashcardsUseCase;
  late final CreateFlashcardUseCase _createFlashcardUseCase;
  late final UpdateFlashcardUseCase _updateFlashcardUseCase;
  late final DeleteFlashcardUseCase _deleteFlashcardUseCase;

  bool get isAuthenticated => _tokenStore.hasToken;

  void _build() {
    // --- Núcleo compartido ---
    _tokenStore = TokenStore(_prefs);
    _apiClient = ApiClient(_tokenStore);

    // --- Auth: datasource -> repository -> usecases ---
    final authDataSource = AuthRemoteDataSource(_apiClient);
    _authRepository = AuthRepositoryImpl(authDataSource);
    _loginUseCase = LoginUseCase(_authRepository);
    _registerUseCase = RegisterUseCase(_authRepository);

    // --- Flashcards: datasource -> repository -> usecases ---
    final flashcardsDataSource = FlashcardsRemoteDataSource(_apiClient);
    _flashcardRepository = FlashcardRepositoryImpl(flashcardsDataSource);
    _getFlashcardsUseCase = GetFlashcardsUseCase(_flashcardRepository);
    _createFlashcardUseCase = CreateFlashcardUseCase(_flashcardRepository);
    _updateFlashcardUseCase = UpdateFlashcardUseCase(_flashcardRepository);
    _deleteFlashcardUseCase = DeleteFlashcardUseCase(_flashcardRepository);
  }

  /// Providers de los ViewModels para `MultiProvider`.
  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(
            loginUseCase: _loginUseCase,
            registerUseCase: _registerUseCase,
            tokenStore: _tokenStore,
          ),
        ),
        ChangeNotifierProvider<FlashcardsViewModel>(
          create: (_) => FlashcardsViewModel(
            getFlashcards: _getFlashcardsUseCase,
            createFlashcard: _createFlashcardUseCase,
            updateFlashcard: _updateFlashcardUseCase,
            deleteFlashcard: _deleteFlashcardUseCase,
          ),
        ),
      ];
}
