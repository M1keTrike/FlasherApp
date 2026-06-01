import '../entities/flashcard.dart';

abstract class FlashcardRepository {
  Future<List<Flashcard>> getAll();

  Future<Flashcard> create({
    required String question,
    required String answer,
    required String category,
  });

  Future<Flashcard> update({
    required String id,
    required String question,
    required String answer,
    required String category,
  });

  Future<void> delete(String id);
}
