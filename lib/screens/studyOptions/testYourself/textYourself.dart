import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:makequiz/utils.dart';
import '../../../components/Nav.dart';
import '../../home/home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class QuestionAnswerPage extends StatefulWidget {
  final String question;
  final String answer;
  final int num;

  const QuestionAnswerPage(
      {Key? key,
      required this.question,
      required this.answer,
      required this.num})
      : super(key: key);

  @override
  State<QuestionAnswerPage> createState() => _QuestionAnswerPage();
}

class _QuestionAnswerPage extends State<QuestionAnswerPage> {
  final TextEditingController _textEditingController = TextEditingController();
  List texts = ['', ''];
  bool hintMade = false;
  bool solutionMade = false;
  int _selectedIndex = -1;
  Future? _hintFuture;
  Future? _solutionFuture;

  Future<void> getGrades(String userAnswer, String course) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.181:5001/generate_score'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': userAnswer,
          'actual': widget.answer,
          'course': course,
        }),
      );

      if (response.statusCode == 200) {
        var suggestion = response.body;
        suggestion = suggestion.replaceAll('\"', "");
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            texts[1] = suggestion;
          });
        }
      } else {
        print('Failed to process image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while processing image: $e');
    }
  }

  Future<void> getHint(String question, String answer) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.181:5001/generate_hint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': question,
          'answer': answer,
        }),
      );

      if (response.statusCode == 200) {
        var suggestion = response.body;
        suggestion = suggestion.replaceAll('\"', "");
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            texts[0] = suggestion;
          });
        }
      } else {
        print('Failed to process image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while processing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 15),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '${widget.num + 1}.',
          style: const TextStyle(fontSize: 25),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.question,
          textAlign: TextAlign.center,
          style: TextStyle(color: redorange, fontSize: 20),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _textEditingController,
          maxLines: 4,
          decoration: InputDecoration(
            fillColor: textField,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 2.0), // Increase the border width
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 2.0),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(
                1000), // Set a large value for the left semi-circular edge
            right: Radius.circular(
                1000), // Set a large value for the right semi-circular edge
          ),
          child: Container(
            color: Colors.grey.shade100, // Set the color to white
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildTextButton('Get a Hint', 0)),
                Expanded(child: _buildTextButton('Solution/Grade Yourself', 1)),
              ],
            ),
          ),
        ),
      ),
      _selectedIndex == -1
          ? Container()
          : _selectedIndex == 0
              ? showHint()
              : showSolution()
    ]);
  }

  Widget showSolution() {
    return FutureBuilder(
      future: _solutionFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedTextKit(animatedTexts: [
              TypewriterAnimatedText(texts[1], textAlign: TextAlign.center)
            ], totalRepeatCount: 1),
          );
        }
        return LoadingAnimationWidget.staggeredDotsWave(
          color: redorange,
          size: 50,
        );
      },
    );
  }

  Widget showHint() {
    return FutureBuilder(
      future: _hintFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  texts[0],
                  textAlign: TextAlign.center,
                )
              ],
              totalRepeatCount: 1,
            ),
          );
        }
        return LoadingAnimationWidget.staggeredDotsWave(
          color: redorange,
          size: 50,
        );
      },
    );
  }

  Widget _buildTextButton(String text, int index) {
    return TextButton(
      onPressed: () {
        setState(() {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          _selectedIndex = index;
          if (index == 0 && !hintMade) {
            _hintFuture = getHint(widget.question, widget.answer);
            hintMade = true;
          } else if (index == 1 && !solutionMade) {
            _solutionFuture =
                getGrades(_textEditingController.text, widget.answer);
            solutionMade = true;
          }
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: _selectedIndex == index
            ? Colors.orange.shade100
            : Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.orange : Colors.grey,
        ),
      ),
    );
  }
}

class TextYourself extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  const TextYourself({Key? key, required this.questions}) : super(key: key);

  @override
  State<TextYourself> createState() => _QuestionsFlow();
}

class _QuestionsFlow extends State<TextYourself> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: nav("Text Yourself", context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: widget.questions
                .map<Widget>((questionData) => QuestionAnswerPage(
                      question: questionData['question'] ?? '',
                      answer: questionData['answer'] ?? '',
                      num: widget.questions.indexOf(questionData),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
