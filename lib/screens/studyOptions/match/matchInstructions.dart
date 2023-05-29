import 'package:flutter/material.dart';
import 'package:makequiz/screens/studyOptions/match/match.dart';
import 'package:makequiz/utils.dart';

import '../../../components/Nav.dart';
import '../../../models/question.dart';


class MatchInstructions extends StatelessWidget {
  final QuestionsList question;

  const MatchInstructions({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: nav("Instructions", context),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(children: [
            const SizedBox(height: 100),
            Text("Make everything disappear!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            Text(
                "Drag corresponding items onto each other to make them disappear.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            TextButton(
                onPressed: () {
                  navigate(Match(data: question.questions), context);
                },
                child: Container(
                    color: redorange,
                    padding: EdgeInsets.all(20),
                    child: Text("Start Studying",
                    textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))))
          ]),
        ));
  }
}
