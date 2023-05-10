import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:makequiz/screens/home.dart';
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
  String? _nameError;

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
        print(_notes);
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
      String recognizedText, String name, String topic) async {
    setState(() {
      _sendingText = true;
    });
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
    } finally {
      setState(() {
        _sendingText = false;
      });
    }
    return _questions;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: bgColor,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _takenImages.isEmpty
                        ? const Center(
                            child: Text(
                            'No images selected.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.black,
                            ),
                          ))
                        : GridView.builder(
                            shrinkWrap: true,
                            itemCount: _takenImages.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        _takenImages.length <= 2 ? 1 : 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 0.65),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Image.file(
                                  _takenImages[index],
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                          )),
                !loadingText && !_sendingText
                    ? actions()
                    : LoadingAnimationWidget.threeArchedCircle(color: redorange, size: 125)
              ],
            ),
          ),
        ));
  }

  Widget _buildButton({
    required Color backgroundColor,
    required Icon icon,
    required double size,
    required VoidCallback onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Material(
        color: Colors.transparent, // Make the material widget transparent
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                  color: Colors.black, width: 2.5), // Add border here
            ),
            child: icon,
          ),
        ),
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

  Future<void> _checkName(String name) async {
  bool nameExists = await dbHelper.isNameExist(name);
  setState(() {
    _nameError = nameExists ? 'Name already exists' : null;
  });
}


  // ...

  Widget actions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: _buildButton(
            size: 60,
            backgroundColor: Colors.grey,
            icon: const Icon(Icons.add,
                color: Colors.black, size: 40, weight: 600),
            onPressed: () {
              getImages();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: _buildButton(
            size: 80,
            backgroundColor: Colors.deepOrangeAccent,
            icon: const Icon(Icons.camera_alt_outlined,
                color: Colors.white, size: 50, weight: 500),
            onPressed: () {
              takeImage();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: _buildButton(
            size: 60,
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check,
                color: Colors.black, size: 40, weight: 600),
            onPressed: () {
              _showTopicInputDialog(context);
            },
          ),
        ),
      ],
    );
  }

  void _showTopicInputDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController topicController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

      InputDecoration curvedTextFieldDecoration(String text) {
    return InputDecoration(
      hintText: text,
      fillColor: textField,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.grey[700],
          ),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: const Text(
              'Enter the name and topic',
              style: TextStyle(color: Colors.white),
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  TextFormField(
                    
                    controller: nameController,
                    decoration: curvedTextFieldDecoration('Name'),
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return _nameError;
                  },
                  onChanged: (value) {
                    _checkName(value);
                  },
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  TextFormField(
                    controller: topicController,
                     decoration: curvedTextFieldDecoration("Topic"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a topic';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.of(context).pop();
                    try {
                      String name= nameController.text;
                      String topic = topicController.text;
                      sendRecognizedText(_notes, name, topic).then((_) {
                        if (!_sendingText) {
                          _showModal();
                        }
                      });
                    } catch (e) {
                      print('Error while sending recognized text: $e');
                      // You can also display the error to the user by updating the UI accordingly.
                    }
                  }
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
