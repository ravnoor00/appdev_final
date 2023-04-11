import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'questions.dart';
import '../database_helper.dart';
import '../models/question.dart';
import 'flashcards.dart';
import 'package:makequiz/models/flashcard.dart';
import 'feynman.dart';
import '../components/study_options.dart';

class ImageToText extends StatefulWidget {
  const ImageToText({Key? key}) : super(key: key);

  @override
  State<ImageToText> createState() => _ImageToText();
}

class _ImageToText extends State<ImageToText> {
  File? _image;
  String _responseText = '';
  bool _sendingText = false;
  List<Map<String, dynamic>> _questions = [];
  String _notes = '';
  bool loadingText = false;
  final List<File> _takenImages = [];
  final TextEditingController _courseController = TextEditingController();

  late DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  Future takeImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _takenImages.add(_image!);
        loadingText = true;
      });

      if (_image != null) {
        final recognizedText = await recognizeText(_image!);
        _notes += '$recognizedText + New Page';
        setState(() {
          loadingText = false;
        });
      } else {
        print('No image selected');
      }
    }
  }

  Future<void> getImages() async {
    List<XFile> images;
    try {
      images = await ImagePicker().pickMultiImage();
    } catch (e) {
      print('Error while picking images: $e');
      images = [];
    }

    if (images.isNotEmpty) {
      int recognizedImages = 0;
      setState(() {
        loadingText = true;
      });

      for (var img in images) {
        final imageFile = File(img.path);
        _takenImages.add(imageFile); // Add the image to the list
        final recognizedText = await recognizeText(imageFile);
        print(recognizedText);
        _notes += recognizedText;
        recognizedImages++;

        if (recognizedImages == images.length) {
          setState(() {
            loadingText = false;
          });
        }
      }
    } else {
      print('No images selected');
    }
  }

  Future<String> recognizeText(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textDetector.processImage(inputImage);
      textDetector.close();
      return recognizedText.text;
    } catch (e) {
      print('Error while recognizing text: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> sendRecognizedText(
      String recognizedText, String course) async {
    setState(() {
      _sendingText = true;
    });
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.206:5001/process_image'),
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
        dbHelper.insertList(QuestionsList(_questions, course));
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

  List<Map<String, dynamic>> stringtoJSON(String reply) {
    RegExp jsonSeparatorPattern = RegExp(r'}\s*,\s*{');
    List<String> jsonStrings = reply.split(jsonSeparatorPattern);

    List<Map<String, dynamic>> jsonObjects = [];

    for (String jsonStr in jsonStrings) {
      // Add curly braces if needed
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _takenImages.isEmpty
                ? const Text('No images selected.')
                : GridView.builder(
                    shrinkWrap: true,
                    itemCount: _takenImages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(_takenImages[index]);
                    },
                  ),
            Text(_responseText),
            TextField(
              controller: _courseController,
              decoration: const InputDecoration(
                hintText: 'Enter your course',
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              ),
            ),
            actions(),
            const SizedBox(height: 25),
            !loadingText && !_sendingText
                ? ElevatedButton(
                    onPressed: () {
                      try {
                        String course = _courseController.text.isEmpty
                            ? ''
                            : _courseController.text;
                        sendRecognizedText(_notes, course).then((_) {
                          if (!_sendingText) {
                            _showModal(context);
                          }
                        });
                      } catch (e) {
                        print('Error while sending recognized text: $e');
                        // You can also display the error to the user by updating the UI accordingly.
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Adjust the corner radius as desired
                      ),
                    ),
                    child: const Text('Get Questions'),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    ));
  }

  void _showModal(BuildContext context) {
    showModalMenu(
      context,
      onQuestionsFile: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionsFlow(questions: _questions),
          ),
        );
      },
      onFlashcards: () {
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
          builder: (context) => FeynmanFlow(
           questions: _questions, currentQuestionIndex: 0),
                ),
              );
       },
    );
  }

  // ...


  Widget actions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          heroTag: 'Gallery',
          backgroundColor: Colors.orange[800],
          onPressed: getImages,
          tooltip: 'Pick Images from Gallery',
          child: const SizedBox(
              width: 50,
              child: Icon(
                Icons.photo_library,
              )),
        ),
        const SizedBox(width: 30),
        FloatingActionButton(
          heroTag: 'Camera',
          backgroundColor: Colors.grey,
          onPressed: takeImage,
          tooltip: 'Pick Image from Camera',
          child: const SizedBox(
              width: 50,
              child: Icon(
                Icons.add_a_photo,
              )),
        ),
      ],
    );
  }
}
