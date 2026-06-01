import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

/// Caso de uso: crear una flashcard.
class CreateFlashcardUseCase {
  const CreateFlashcardUseCase(this._repository);

  final FlashcardRepository _repository;

  Future<Flashcard> call({
    required String question,
    required String answer,
    required String category,
  }) {
    return _repository.create(
      question: question,
      answer: answer,
      category: category,
    );
  }
}
