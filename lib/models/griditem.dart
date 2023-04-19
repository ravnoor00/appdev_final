enum GridItemType { question, answer }

class GridItem {
  GridItemType type;
  String content;
  bool isMatched;
  bool notSelected;
  bool incorrect;
  bool correct;

  GridItem({
    required this.type,
    required this.content,
    required this.isMatched,
    required this.notSelected,
    this.incorrect = false,
    this.correct = false, // Add this line
  });
}