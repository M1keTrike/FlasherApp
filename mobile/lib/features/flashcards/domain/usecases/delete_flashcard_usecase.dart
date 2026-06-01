import '../repositories/flashcard_repository.dart';

class DeleteFlashcardUseCase {
  const DeleteFlashcardUseCase(this._repository);

  final FlashcardRepository _repository;

  Future<void> call(String id) => _repository.delete(id);
}
