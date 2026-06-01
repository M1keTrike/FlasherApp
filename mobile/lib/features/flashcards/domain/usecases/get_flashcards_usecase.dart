import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class GetFlashcardsUseCase {
  const GetFlashcardsUseCase(this._repository);

  final FlashcardRepository _repository;

  Future<List<Flashcard>> call() => _repository.getAll();
}
