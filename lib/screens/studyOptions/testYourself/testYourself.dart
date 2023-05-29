import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:makequiz/utils.dart';
import '../../../components/Nav.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Test extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  const Test({Key? key, required this.questions}) : super(key: key);

  @override
  State<Test> createState() => _Test();
}

class _Test extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: nav("Test", context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: widget.questions
                .map<Widget>((questionData) => TestItem(
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

class TestItem extends StatefulWidget {
  final String question;
  final String answer;
  final int num;

  const TestItem(
      {Key? key,
      required this.question,
      required this.answer,
      required this.num})
      : super(key: key);

  @override
  State<TestItem> createState() => _TestItem();
}

class _TestItem extends State<TestItem> {
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
        Uri.parse('http://192.168.1.247:5001/generate_score'),
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
        Uri.parse('http://192.168.1.247:5001/generate_hint'),
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
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.num + 1}.',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Text(
            widget.question,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[800], fontSize: 15),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _textEditingController,
          maxLines: 4,
          decoration: InputDecoration(
            fillColor: Colors.grey[100],
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildTextButton('Get a Hint', 0)),
              const SizedBox(width: 10),
              Expanded(child: _buildTextButton('Solution/Grade Yourself', 1)),
            ],
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
            ? Colors.orange.shade200
            : Colors.orange[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.brown : Colors.brown,
        ),
      ),
    );
  }
}
