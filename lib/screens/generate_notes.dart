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
import '../components/Nav.dart';

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
  String? _nameError;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  Future<void> _checkName(String name) async {
    bool nameExists = await dbHelper.isNameExist(name);
    setState(() {
      _nameError = nameExists ? 'Name already exists' : null;
    });
  }

  Future<List<Map<String, dynamic>>> sendNotesText(
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

  Future<List<Map<String, dynamic>>> sendPromptText(
      String text, String name, String topic) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.247:5001/generate_questions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
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
      backgroundColor: yellow,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Generate your Own Questions'),
        foregroundColor: Colors.black,
        backgroundColor: yellow,
      ),
      drawer: sidebar(context),
      body: Stack(
        children: [
          AbsorbPointer(
              absorbing: _loading,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    // Add SingleChildScrollView here
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border:
                                        Border.all(color: Colors.grey[50]!)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Name',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13)),
                                      const SizedBox(height: 3.0),
                                      TextFormField(
                                        controller: _nameController,
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a name';
                                          }
                                          return _nameError;
                                        },
                                        onChanged: (value) {
                                          _checkName(value);
                                        },
                                      ),
                                    ]))),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border:
                                        Border.all(color: Colors.grey[50]!)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Topic',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13)),
                                      const SizedBox(height: 3.0),
                                      TextFormField(
                                        controller: _topicController,
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a name';
                                          }
                                          return _nameError;
                                        },
                                        onChanged: (value) {
                                          _checkName(value);
                                        },
                                      ),
                                    ]))),
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
                            ? Padding(
                                // Add padding here
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: _notesController,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey[50]!,
                                            width: 0.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey[50]!,
                                            width: 0.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey[50]!,
                                            width: 0.5),
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please paste your notes';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : Padding(
                                // Add padding here
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: _questionsController,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey[50]!,
                                            width: 0.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey[50]!,
                                            width: 0.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey[50]!,
                                            width: 0.5),
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please generate your questions';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              )),
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
            _showNotesField
                ? sendNotesText(_notesController.text, _nameController.text,
                    _topicController.text)
                : sendPromptText(_questionsController.text,
                        _nameController.text, _topicController.text)
                    .then((_) {
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


