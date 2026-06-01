import '../repositories/flashcard_repository.dart';

/// Caso de uso: eliminar una flashcard.
class DeleteFlashcardUseCase {
  const DeleteFlashcardUseCase(this._repository);

  final FlashcardRepository _repository;

  Future<void> call(String id) => _repository.delete(id);
}
