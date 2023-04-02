import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuestionAnswerPage extends StatefulWidget {
  final String question;
  final String answer;

  const QuestionAnswerPage(
      {super.key, required this.question, required this.answer});

  @override
  State<QuestionAnswerPage> createState() => _QuestionAnswerPage();
}

class _QuestionAnswerPage extends State<QuestionAnswerPage> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _submitted = false;
  String? _responseText;
  Future? _gradesFuture;

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
        _responseText = suggestion.substring(suggestion.lastIndexOf(':') + 1, suggestion.lastIndexOf('.') + 1);
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
        Card(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.question),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textEditingController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Enter your answer...',
                    fillColor: Colors.transparent,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        setState(() {
                          _submitted = true;
                          _gradesFuture = getGrades(
                              _textEditingController.text, widget.answer);
                          FocusManager.instance.primaryFocus?.unfocus();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_submitted)
          FutureBuilder(
            future: _gradesFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_responseText ?? ''),
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}

class QuestionsFlow extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final int currentQuestionIndex;

  const QuestionsFlow(
      {super.key, required this.questions, required this.currentQuestionIndex});

  @override
  _QuestionsFlowState createState() => _QuestionsFlowState();
}

class _QuestionsFlowState extends State<QuestionsFlow> {
  void _nextQuestion() {
    if (widget.currentQuestionIndex < widget.questions.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionsFlow(
            questions: widget.questions,
            currentQuestionIndex: widget.currentQuestionIndex + 1,
          ),
        ),
      );
    }
  }

  void _previousQuestion() {
    if (widget.currentQuestionIndex > 0) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Question ${widget.currentQuestionIndex + 1}')),
      body: QuestionAnswerPage(
        question:
            widget.questions[widget.currentQuestionIndex]['question'] ?? '',
        answer: widget.questions[widget.currentQuestionIndex]['answer'] ?? '',
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousQuestion,
                icon: Icon(Icons.arrow_back),
                tooltip: 'Previous Question',
                disabledColor: Colors.grey,
                color:
                    widget.currentQuestionIndex > 0 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                onPressed: _nextQuestion,
                icon: Icon(Icons.arrow_forward),
                tooltip: 'Next Question',
                disabledColor: Colors.grey,
                color: widget.currentQuestionIndex < widget.questions.length - 1
                    ? Colors.blue
                    : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
