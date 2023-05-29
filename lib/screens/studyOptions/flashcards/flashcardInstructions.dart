import 'package:flutter/material.dart';
import 'package:makequiz/components/FlashCard.dart';
import 'package:makequiz/models/question.dart';
import 'package:makequiz/utils.dart';

import '../../../components/Nav.dart';
import '../../../models/flashcard.dart';
import 'flashcards.dart';

class FlashcardInstructions extends StatelessWidget {
  final QuestionsList questions;

  const FlashcardInstructions({Key? key, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Flashcard> flashcardData = generateFlashcards(questions.questions);
    return Scaffold(
      appBar: nav("Instructions", context),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              "Study with Flashcards",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            const Text(
              "Flashcards are a great way to memorize your notes and are the most versatile study material.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                navigate(
                    Flashcards(
                      flashcards: flashcardData,
                    ),
                    context);
              },
              child: Container(
                color: redorange,
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "Start Studying",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
