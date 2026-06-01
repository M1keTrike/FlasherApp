import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../datasources/flashcards_remote_datasource.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  FlashcardRepositoryImpl(this._remote);

  final FlashcardsRemoteDataSource _remote;

  @override
  Future<List<Flashcard>> getAll() => _remote.getAll();

  @override
  Future<Flashcard> create({
    required String question,
    required String answer,
    required String category,
  }) {
    return _remote.create(question, answer, category);
  }

  @override
  Future<Flashcard> update({
    required String id,
    required String question,
    required String answer,
    required String category,
  }) {
    return _remote.update(id, question, answer, category);
  }

  @override
  Future<void> delete(String id) => _remote.delete(id);
}
