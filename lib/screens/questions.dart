import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:makequiz/utils.dart';
import 'home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class QuestionAnswerPage extends StatefulWidget {
  final String question;
  final String answer;
  final int num;

const QuestionAnswerPage(
    {Key? key, required this.question, required this.answer, required this.num})
    : super(key: key);


  @override
  State<QuestionAnswerPage> createState() => _QuestionAnswerPage();
}

class _QuestionAnswerPage extends State<QuestionAnswerPage> {
  final TextEditingController _textEditingController = TextEditingController();
  String _responseText = '';
  String _hintText = '';
  bool hintMade = false;
  bool solutionMade = false;
  int _selectedIndex = -1;
  String? hint;
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
suggestion = suggestion.substring(
    suggestion.lastIndexOf(':') + 2, suggestion.lastIndexOf('.') + 1)
    .replaceAll('\"', "");
        _responseText = suggestion;
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
        Uri.parse('http://192.168.1.206:5001/generate_hint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': question,
          'answer': answer,
        }),
      );

      if (response.statusCode == 200) {
        var suggestion = response.body;
suggestion = suggestion.substring(
    suggestion.lastIndexOf(':') + 2, suggestion.lastIndexOf('.') + 1)
    .replaceAll('\"', "");

        _hintText = suggestion;
      } else {
        print('Failed to process image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while processing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${widget.num + 1}.'),
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
                borderRadius: BorderRadius.circular(8.0), // Add curved edges
                borderSide: const BorderSide(
                    color: Colors.grey, width: 1.0), // Add a gray border
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildTextButton('Hint', 0)),
                const Text('|'),
                Expanded(child: _buildTextButton('Solution/Grade Your Own', 1)),
              ],
            )),
        _selectedIndex == -1
            ? Container()
            : _selectedIndex == 0
                ? showHint()
                : showSolution()
      ],
    );
  }

  Widget showSolution() {
    if (_responseText != '') {
      return AnimatedTextKit(animatedTexts: [
        TypewriterAnimatedText(_responseText, textAlign: TextAlign.center)
      ]);
    }
    if (solutionMade == true) {
      return LoadingAnimationWidget.staggeredDotsWave(
        color: redorange,
        size: 200,
      );
    }
    return FutureBuilder(
      future: _solutionFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        solutionMade = true;
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedTextKit(animatedTexts: [
              TypewriterAnimatedText(_responseText, textAlign: TextAlign.center)
            ]),
          );
        }
        return LoadingAnimationWidget.staggeredDotsWave(
          color: redorange,
          size: 200,
        );
      },
    );
  }

  Widget showHint() {
    if (_hintText != '') {
      return AnimatedTextKit(animatedTexts: [
        TypewriterAnimatedText(_hintText, textAlign: TextAlign.center)
      ]);
    }
    if (hintMade == true) {
      return LoadingAnimationWidget.staggeredDotsWave(
        color: redorange,
        size: 200,
      );
    }
    return FutureBuilder(
      future: _hintFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        hintMade = true;
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedTextKit(animatedTexts: [
              TypewriterAnimatedText(_hintText, textAlign: TextAlign.center)
            ]),
          );
        }
        return LoadingAnimationWidget.staggeredDotsWave(
          color: redorange,
          size: 200,
        );
      },
    );
  }

  Widget _buildTextButton(String text, int index) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
           if (index == 0 && !hintMade) {
      _hintFuture = getHint(widget.question, widget.answer);
      hintMade = true;
    } else if (index == 1 && !solutionMade) {
      _solutionFuture = getGrades(_textEditingController.text, widget.answer);
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

class QuestionsFlow extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  const QuestionsFlow({Key? key, required this.questions}) : super(key: key);

  @override
  State<QuestionsFlow> createState() => _QuestionsFlow();
}

class _QuestionsFlow extends State<QuestionsFlow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        backgroundColor: yellow,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Questions',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 4),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            color: redorange,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const Home()),
          ),
          icon: const Icon(Icons.home, color: Colors.black, size: 30),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          return QuestionAnswerPage(
              question: widget.questions[index]['question'] ?? '',
              answer: widget.questions[index]['answer'] ?? '',
              num : index);
        },
      ),
    );
  }
}
