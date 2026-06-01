import '../../../../core/network/api_client.dart';
import '../models/flashcard_model.dart';

class FlashcardsRemoteDataSource {
  FlashcardsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<FlashcardModel>> getAll() async {
    final json = await _apiClient.get('/flashcards');
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
    });
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
    });
    return FlashcardModel.fromJson(json as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    await _apiClient.delete('/flashcards/$id');
  }
}
