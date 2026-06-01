import '../../../../core/network/api_client.dart';
import '../models/flashcard_model.dart';

/// Fuente de datos remota: llamadas HTTP al CRUD /flashcards.
///
/// Aquí se ejercitan los cuatro verbos exigidos por la rúbrica:
/// GET (listar), POST (crear), PUT (actualizar), DELETE (eliminar).
class FlashcardsRemoteDataSource {
  FlashcardsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<FlashcardModel>> getAll() async {
    final json = await _apiClient.get('/flashcards'); // GET
    return (json as List)
        .map((e) => FlashcardModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FlashcardModel> create(
    String question,
    String answer,
    String category,
  ) async {
    final json = await _apiClient.post('/flashcards', {
      'question': question,
      'answer': answer,
      'category': category,
    }); // POST
    return FlashcardModel.fromJson(json as Map<String, dynamic>);
  }

  Future<FlashcardModel> update(
    String id,
    String question,
    String answer,
    String category,
  ) async {
    final json = await _apiClient.put('/flashcards/$id', {
      'question': question,
      'answer': answer,
      'category': category,
    }); // PUT
    return FlashcardModel.fromJson(json as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    await _apiClient.delete('/flashcards/$id'); // DELETE
  }
}
