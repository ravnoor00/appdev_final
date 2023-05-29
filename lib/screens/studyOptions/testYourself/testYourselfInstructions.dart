import 'package:flutter/material.dart';
import 'package:makequiz/screens/studyOptions/match/match.dart';
import 'package:makequiz/utils.dart';

import '../../../components/Nav.dart';
import '../../../models/question.dart';
import 'testYourself.dart';

class TestInstructions extends StatelessWidget {
  final QuestionsList question;
  const TestInstructions({Key? key, required this.question}) : super(key: key);

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
              "Study by Texting Yourself",
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
                navigate(Test(questions: question.questions), context);
              },
              child: Container(
                color: redorange,
                padding: EdgeInsets.all(20),
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
