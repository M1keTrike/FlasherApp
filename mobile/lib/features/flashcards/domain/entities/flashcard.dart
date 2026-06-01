/// Entidad de dominio: una tarjeta de estudio.
class Flashcard {
  const Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });

  final String id;
  final String question;
  final String answer;
  final String category;
}
