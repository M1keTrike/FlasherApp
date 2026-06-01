import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

/// Caso de uso: listar las flashcards del usuario.
class GetFlashcardsUseCase {
  const GetFlashcardsUseCase(this._repository);

  final FlashcardRepository _repository;

  Future<List<Flashcard>> call() => _repository.getAll();
}
