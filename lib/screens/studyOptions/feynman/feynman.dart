import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:makequiz/utils.dart';
import '../../../components/Nav.dart';
import '../../home/home.dart';

class Feynman extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final int currentQuestionIndex;
  const Feynman(
      {Key? key, required this.questions, required this.currentQuestionIndex})
      : super(key: key);

  @override
  _FeynmanState createState() => _FeynmanState();
}

class _FeynmanState extends State<Feynman> {
  void _nextQuestion() {
    if (widget.currentQuestionIndex < widget.questions.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Feynman(
            questions: widget.questions,
            currentQuestionIndex: widget.currentQuestionIndex + 1,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: nav(
          'Question ${widget.currentQuestionIndex + 1}/${widget.questions.length}',
          context),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: FeynmanItem(
          question:
              widget.questions[widget.currentQuestionIndex]['question'] ?? '',
          answer: widget.questions[widget.currentQuestionIndex]['answer'] ?? '',
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        // color: Color(0xFF1E1E1E),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousQuestion,
                icon: Icon(Icons.arrow_back, color: Colors.grey[500]),
                tooltip: 'Previous Question',
                disabledColor: Colors.grey,
                color:
                    widget.currentQuestionIndex > 0 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                onPressed: _nextQuestion,
                icon: Icon(Icons.arrow_forward, color: Colors.grey[500]),
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

  void _previousQuestion() {
    if (widget.currentQuestionIndex > 0) {
      Navigator.pop(context);
    }
  }
}

class FeynmanItem extends StatefulWidget {
  final String question;
  final String answer;

  const FeynmanItem({Key? key, required this.question, required this.answer})
      : super(key: key);

  @override
  _FeynmanItemState createState() => _FeynmanItemState();
}

class _FeynmanItemState extends State<FeynmanItem> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _submitted = false;
  String? _responseText;
  Future? _gradesFuture;

  Future<void> getStudentResponse(
      String teacher, String answer, String question) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.181:5001/generate_student_response'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': teacher,
          'answer': answer,
          'question': question,
        }),
      );

      if (response.statusCode == 200) {
        var student = response.body;
        student = student.substring(
            student.lastIndexOf(':') + 2, student.lastIndexOf('.') + 1);
        student.replaceAll('\"', "");
        _responseText = student;
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(widget.question, style: TextStyle(fontSize: 16)),
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
          ),
        ),
        Container(
          padding: const EdgeInsets.all(6.0),
          child: TextField(
            controller: _textEditingController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your answer...',
              hintStyle: TextStyle(color: Colors.grey),
              // fillColor: Color(0xFF1E1E1E),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  setState(() {
                    _submitted = true;
                    _gradesFuture = getStudentResponse(
                        _textEditingController.text,
                        widget.answer,
                        widget.question);
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
