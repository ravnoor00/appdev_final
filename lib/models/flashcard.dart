class Flashcard {
  final String frontText;
  final String backText;

  Flashcard({required this.frontText, required this.backText});
}

List<Flashcard> generateFlashcards(List<Map<String, dynamic>> jsonData) {
  List<Flashcard> flashcards = [];

  for (var data in jsonData) {
    Flashcard flashcard = Flashcard(
      frontText: data['question'] ?? '',
      backText: data['answer'] ?? '',
    );
    flashcards.add(flashcard);
  }

  return flashcards;
}