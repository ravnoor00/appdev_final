import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:makequiz/models/notes.dart';
import 'package:makequiz/screens/studyOptions/feynman/feynmanInstructions.dart';
import 'package:makequiz/screens/studyOptions/flashcards/flashcards.dart';
import 'package:makequiz/screens/studyOptions/match/matchInstructions.dart';
import 'package:makequiz/screens/studyOptions/testYourself/testYourself.dart';
import '../components/Nav.dart';
import '../components/StudyOptions.dart';
import '../models/flashcard.dart';
import '../utils.dart';
import 'studyOptions/feynman/feynman.dart';
import 'package:makequiz/database_helper.dart';
import 'dart:convert';
import '../models/question.dart';
import 'package:http/http.dart' as http;
import 'studyOptions/flashcards/flashcardInstructions.dart';
import 'studyOptions/match/match.dart';
import 'studyOptions/testYourself/testYourselfInstructions.dart';

class Note extends StatefulWidget {
  final Notes note;
  const Note({super.key, required this.note});
  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  late TextEditingController _notesController;
  bool _sendingText = false;
  bool isLoaded = false;
  late DatabaseHelper dbHelper;
  List<Map<String, dynamic>> _questions = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _notesController = TextEditingController(text: widget.note.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> sendRecognizedText(
      String recognizedText, String name, String topic) async {
    setState(() {
      _sendingText = true;
    });
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.181:5001/process_image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': recognizedText}),
      );

      if (response.statusCode == 200) {
        print(response.body);
        List<Map<String, dynamic>> questions = stringtoJSON(response.body);
        print(questions.toString());
        setState(() {
          _questions = questions;
        });
        dbHelper.insertList(QuestionsList(_questions, name, false, topic));
        isLoaded = false;
      } else {
        print('Failed to process image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while processing image: $e');
    } finally {
      setState(() {
        _sendingText = false;
      });
    }
    return _questions;
  }

  // void _showModal() {
  //   showStudyOptions(context, onQuestionsFile: () {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => TextYourself(questions: _questions),
  //         fullscreenDialog: true,
  //       ),
  //     );
  //   }, onFlashcards: () {
  //     List<Flashcard> flashcards = generateFlashcards(_questions);
  //     Navigator.pop(context);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Flashcards(flashcards: flashcards),
  //       ),
  //     );
  //   }, onFeynman: () {
  //     Navigator.pop(context);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) =>
  //             FeynmanFlow(questions: _questions, currentQuestionIndex: 0),
  //       ),
  //     );
  //   }, onMatch: () {
  //     Navigator.pop(context);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Match(data: _questions),
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(backgroundColor: Color(0xff93BBF6));
    return Scaffold(
      appBar: nav(widget.note.name, context),
      // appBar: AppBar(
      //   toolbarHeight: 60,
      //   foregroundColor: Colors.grey[700],
      //   backgroundColor: bgColor,
      //   elevation: 1,
      //   title: Text("Notes",
      //       style: const TextStyle(
      //           color: Colors.black, fontWeight: FontWeight.bold)),
      //   centerTitle: true,
      //   actions: [
      //     Padding(
      //       padding:
      //           const EdgeInsets.only(right: 8.0), // Change the value as needed
      //       child: IconButton(
      //         icon: const Icon(Icons.edit, color: Colors.black, size: 30),
      //         onPressed: () {
      //           if (_notesController.text.isNotEmpty) {
      //             setState(() {
      //               _sendingText = true;
      //             });
      //             try {
      //               String name = widget.note.name;
      //               String topic = widget.note.topic;
      //               sendRecognizedText(_notesController.text, name, topic)
      //                   .then((_) {
      //                 setState(() {
      //                   _sendingText = false;
      //                 });
      //                 _showModal();
      //               });
      //             } catch (e) {
      //               print('Error while sending recognized text: $e');
      //               // You can also display the error to the user by updating the UI accordingly.
      //             }
      //           }
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.more_vert),
        onPressed: () {
          _showBottomModal();
        },
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: Card(
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.note.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 30,
                            )),
                        const Text("",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                                color: Colors.grey)),
                      ],
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                    !_sendingText
                        ? TextFormField(
                            controller: _notesController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your notes.',
                            ),
                          )
                        : Center(
                            child: LoadingAnimationWidget.threeRotatingDots(
                            color: redorange,
                            size: 150,
                          )),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.6),
                  ],
                ))),
      ),
    );
  }

  void _showBottomModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.library_books_rounded),
                title: const Text('Flashcards'),
                onTap: () => {navigate(const FlashcardInstructions(), context)},
              ),
              ListTile(
                leading: Icon(Icons.text_snippet_rounded),
                title: const Text('Test'),
                onTap: () => {navigate(const TestInstructions(), context)},
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Feynman'),
                onTap: () => {navigate(FeynmanInstructions(), context)},
              ),
              ListTile(
                leading: Icon(Icons.headset),
                title: Text('Match'),
                onTap: () => {navigate(MatchInstructions(), context)},
              ),
            ],
          ),
        );
      },
    );
  }
}
