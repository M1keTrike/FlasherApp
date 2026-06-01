import '../../domain/entities/flashcard.dart';

/// Modelo de datos de Flashcard: (de)serialización JSON.
class FlashcardModel extends Flashcard {
  const FlashcardModel({
    required super.id,
    required super.question,
    required super.answer,
    required super.category,
  });

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      category: json['category'] as String,
    );
  }

  /// Cuerpo que se envía al crear/actualizar (la API ignora el resto).
  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
        'category': category,
      };
}
