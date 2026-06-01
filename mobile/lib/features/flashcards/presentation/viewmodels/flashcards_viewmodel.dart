import 'package:flutter/foundation.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/usecases/create_flashcard_usecase.dart';
import '../../domain/usecases/delete_flashcard_usecase.dart';
import '../../domain/usecases/get_flashcards_usecase.dart';
import '../../domain/usecases/update_flashcard_usecase.dart';

class FlashcardsViewModel extends ChangeNotifier {
  FlashcardsViewModel({
    required GetFlashcardsUseCase getFlashcards,
    required CreateFlashcardUseCase createFlashcard,
    required UpdateFlashcardUseCase updateFlashcard,
    required DeleteFlashcardUseCase deleteFlashcard,
  }) : _getFlashcards = getFlashcards,
       _createFlashcard = createFlashcard,
       _updateFlashcard = updateFlashcard,
       _deleteFlashcard = deleteFlashcard;

  final GetFlashcardsUseCase _getFlashcards;
  final CreateFlashcardUseCase _createFlashcard;
  final UpdateFlashcardUseCase _updateFlashcard;
  final DeleteFlashcardUseCase _deleteFlashcard;

  List<Flashcard> _flashcards = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Flashcard> get flashcards => List.unmodifiable(_flashcards);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => !_isLoading && _flashcards.isEmpty;

  Future<void> load() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _flashcards = await _getFlashcards();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar las tarjetas.';
    }
    _setLoading(false);
  }

  Future<bool> create({
    required String question,
    required String answer,
    required String category,
  }) async {
    return _mutate(
      () => _createFlashcard(
        question: question,
        answer: answer,
        category: category,
      ),
    );
  }

  Future<bool> update({
    required String id,
    required String question,
    required String answer,
    required String category,
  }) async {
    return _mutate(
      () => _updateFlashcard(
        id: id,
        question: question,
        answer: answer,
        category: category,
      ),
    );
  }

  Future<bool> delete(String id) async {
    return _mutate(() => _deleteFlashcard(id));
  }

  Future<bool> _mutate(Future<void> Function() action) async {
    _errorMessage = null;
    try {
      await action();
      await load();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Ocurrió un error inesperado.';
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
