import 'package:flutter/material.dart';
import 'package:makequiz/components/flash_card.dart';
import 'package:makequiz/models/flashcard.dart';

class FlashcardTest extends StatefulWidget {
  final List<Flashcard> flashcards;

  const FlashcardTest({super.key, required this.flashcards});

  @override
  State<FlashcardTest> createState() => _FlashcardTest();
}

class _FlashcardTest extends State<FlashcardTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Test'),
      ),
      body: PageView.builder(
        itemCount: widget.flashcards.length,
        itemBuilder: (BuildContext context, int index) {
          final flashcardhere = widget.flashcards[index];
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlipCard(
                flashcard: Flashcard(frontText: flashcardhere.frontText, backText: flashcardhere.backText),
              ),
            ),
          );
        },
      ),
    );
  }
}
