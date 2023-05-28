import 'package:flutter/material.dart';
import 'package:makequiz/screens/studyOptions/match/match.dart';
import 'package:makequiz/utils.dart';

import '../../../components/Nav.dart';
import '../../../models/question.dart';
import 'feynman.dart';

QuestionsList temporary = QuestionsList([
  {'question': 'Is Jeffrey gay?', 'answer': 'Yes, he is.'},
  {'question': 'Is Jeffrey gay?', 'answer': 'Yes, he is.'},
  {'question': 'Is Jeffrey gay?', 'answer': 'Yes, he is.'}
], 'hi', false, 'random');

class FeynmanInstructions extends StatelessWidget {
  const FeynmanInstructions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: nav("Instructions", context),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              "Study using Feynman's Technique",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            const Text(
              "The Feynman Technique is a method for learning and reinforcing knowledge. It involves explaining a concept in simple terms as if you were teaching it to someone else.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                navigate(
                    Feynman(
                        questions: mockJsonData[0]['questions'],
                        currentQuestionIndex: 0),
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
