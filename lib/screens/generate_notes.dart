import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'questions.dart';
import '../database_helper.dart';
import '../models/question.dart';
import 'flashcards.dart';
import 'package:makequiz/models/flashcard.dart';
import 'feynman.dart';
import '../components/study_options.dart';
import 'package:makequiz/utils.dart';
import 'match.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GenerateNotes extends StatefulWidget {
  const GenerateNotes({Key? key}) : super(key: key);

  @override
  State<GenerateNotes> createState() => _GenerateNotes();
}

class _GenerateNotes extends State<GenerateNotes> {
  late DatabaseHelper dbHelper;
  String _responseText = '';
  List<Map<String, dynamic>> _questions = [];
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _questionsController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
    bool _showNotesField = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  List<Map<String, dynamic>> stringtoJSON(String reply) {
    RegExp jsonSeparatorPattern = RegExp(r'}\s*,\s*{');
    List<String> jsonStrings = reply.split(jsonSeparatorPattern);

    List<Map<String, dynamic>> jsonObjects = [];

    for (String jsonStr in jsonStrings) {
      if (!jsonStr.startsWith('{')) {
        jsonStr = '{$jsonStr';
      }
      if (!jsonStr.endsWith('}')) {
        jsonStr = '$jsonStr}';
      }

      Map<String, dynamic> jsonObject = jsonDecode(jsonStr);
      jsonObjects.add(jsonObject);
    }
    return jsonObjects;
  }


  Future<List<Map<String, dynamic>>> sendRecognizedText(
      String recognizedText, String name, String topic) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.247:5001/process_image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': recognizedText}),
      );

      if (response.statusCode == 200) {
        print(response.body);
        List<Map<String, dynamic>> questions = stringtoJSON(response.body);
        print(questions.toString());
        setState(() {
          _responseText = response.body;
          _questions = questions;
        });
        dbHelper.insertList(QuestionsList(_questions, name, false, topic));
        isLoaded = false;
      } else {
        print('Failed to process image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while processing image: $e');
    }
    return _questions;
  }



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Page')),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter your topic'),
                  TextFormField(
                    controller: _nameController,
                    maxLines: 1,
                    decoration: _roundedTextFieldDecoration(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a topic';
                      }
                      return null;
                    },
                  ),
                  Text('Enter the name'),
                  TextFormField(
                    controller: _topicController,
                    maxLines: 1,
                    decoration: _roundedTextFieldDecoration(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_showNotesField
                          ? 'Paste your notes'
                          : 'Generate your questions'),
                      CupertinoSwitch(
                        value: _showNotesField,
                        onChanged: (bool value) {
                          setState(() {
                            _showNotesField = value;
                          });
                        },
                      ),
                    ],
                  ),
                  _showNotesField
                      ? TextFormField(
                          controller: _notesController,
                          maxLines:
                              _notesController.text.length > 80 ? null : 4,
                          decoration: _roundedTextFieldDecoration(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please paste your notes';
                            }
                            return null;
                          },
                        )
                      : TextFormField(
                          controller: _questionsController,
                          maxLines: 2,
                          decoration: _roundedTextFieldDecoration(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please generate your questions';
                            }
                            return null;
                          },
                        ),
                ],
              ),
            ),
          ),
          if (_loading) // Show CircularProgressIndicator if _loading is true
            Center(
                child: LoadingAnimationWidget.threeRotatingDots(
              color: redorange,
              size: 150,
            )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _loading = true;
            });
            sendRecognizedText(
              _showNotesField
                  ? _notesController.text
                  : _questionsController.text,
              _nameController.text,
              _topicController.text,
            ).then((_) {
              setState(() {
                _loading = false;
              });
              _showModal();
            });
          }
        },
        child: const Icon(Icons.notes),
      ),
    );
  }

  void _showModal() {
    showModalMenu(context, onQuestionsFile: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionsFlow(questions: _questions),
          fullscreenDialog: true,
        ),
      );
    }, onFlashcards: () {
      List<Flashcard> flashcards = generateFlashcards(_questions);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlashcardTest(flashcards: flashcards),
        ),
      );
    }, onFeynman: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FeynmanFlow(questions: _questions, currentQuestionIndex: 0),
        ),
      );
    }, onMatch: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Match(data: _questions),
        ),
      );
    });
  }
}

InputDecoration _roundedTextFieldDecoration() {
  return InputDecoration(
    fillColor: textField,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 2.0),
    ),
  );
}
