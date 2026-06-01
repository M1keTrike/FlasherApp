import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class UpdateFlashcardUseCase {
  const UpdateFlashcardUseCase(this._repository);

  final FlashcardRepository _repository;

  Future<Flashcard> call({
    required String id,
    required String question,
    required String answer,
    required String category,
  }) {
    return _repository.update(
      id: id,
      question: question,
      answer: answer,
      category: category,
    );
  }
}
