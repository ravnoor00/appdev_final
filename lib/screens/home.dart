import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makequiz/components/Sidebar.dart';
import 'package:makequiz/models/flashcard.dart';
import '../components/Nav.dart';
import '../components/study_options.dart';
import '../utils.dart';
import '../models/question.dart';
import '../database_helper.dart';
import 'feynman.dart';
import 'flashcards.dart';
import 'questions.dart';
import 'match.dart';
import '../components/bookmark.dart';
import '../components/togglebuttons.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

bool isLoaded = false;

class _Home extends State<Home> {
  var width;
  late DatabaseHelper dbHelper;
  int _selectedButtonIndex = 0;

void _onButtonChanged(int index, bool isSelected) {
  setState(() {
    if (isSelected) {
      _selectedButtonIndex = index;
    } else {
      _selectedButtonIndex = 0; 
    }
  });
}


  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  List topics = ['All', "Bookmarks"];

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: yellow,
        appBar: nav("Hello, Ravnoor", context),
        body: Container(
          margin: const EdgeInsets.all(25),
          child: Column(children: [heading(), buttons(), _fetchData(), Sidebar()]),
        ));
  }

  Widget heading() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text("My Questions",
          style: TextStyle(
              fontSize: 65,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800])),
    );
  }

  Widget _fetchData() {
    return FutureBuilder<List<QuestionsList>>(
      future: _selectedButtonIndex == 0
          ? dbHelper.queryAllRows()
          : _selectedButtonIndex == 1
              ? dbHelper.queryAllBookMarked()
              : dbHelper.queryByTopic(topics[_selectedButtonIndex]),
      builder:
          (BuildContext context, AsyncSnapshot<List<QuestionsList>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.data!.isEmpty) {
            return const Text('Scan your notes', textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.w600));
          }
          return noteCards(snapshot.data!);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buttons() {
    return isLoaded == true
        ? Row(
            children: List.generate(
                topics.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0),
                  child: CustomToggleButton(
                    title: topics[index],
                    onChanged: (isSelected) =>
                        _onButtonChanged(index, isSelected),
                    isSelected: _selectedButtonIndex == index)),
          ))
        : FutureBuilder<List<String>>(
            future: dbHelper.getAllTopics(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
            topics = ['All', 'Bookmarks', ...snapshot.data!];
                isLoaded = true;
                return Row(
                  children: List.generate(
                      topics.length,
                      (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0),
                  child: CustomToggleButton(
                          title: topics[index],
                          onChanged: (isSelected) =>
                              _onButtonChanged(index, isSelected),
                          isSelected: _selectedButtonIndex == index)),
                ));
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
  }

  Widget noteCards(List<QuestionsList> data) {
    List<Widget> noteCardWidgets =
        data.map((questionList) => noteCard(questionList)).toList();

    return Flexible(
        child: GridView.count(
      childAspectRatio: 0.55,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      crossAxisCount: 2,
      children: noteCardWidgets,
    ));
  }

  Widget noteCard(QuestionsList questionList) {
    return InkWell(
      onTap: () {
        _showModal(context, questionList.questions);
      },
      child: Stack(
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black, width: 1),
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                ...List.generate(
                  25,
                  (index) => const Divider(color: Colors.grey, height: 10),
                ),
              ],
            ),
          ),
          Positioned(
            left: 15,
            top: 5,
            bottom: 3,
            child: Container(
              width: 2, // Change this value to adjust the thickness of the line
              color: Colors.red[200],
            ),
          ),
          Positioned(
            top: 15,
            left: 30,
            child: Text(
              questionList.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 6,
            right: 20,
            child: CustomBookmarkIcon(
              initialValue: questionList.isBookmarked,
              onChanged: (newValue) async {
                await dbHelper.updateBookmarkedStatus(
                    questionList.name, newValue);
                setState(() {});
              },
            ),
          ),
          Positioned(
            bottom: -4,
            right: 1,
            child: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('Delete Note'),
                        onPressed: () async {
                          await dbHelper.deleteRow(questionList.name);
                          setState(() {
                            isLoaded = false;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('Change Name'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showNameChangeDialog(context, questionList);
                        },
                      ),
                    ],
                    cancelButton: CupertinoDialogAction(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showModal(BuildContext context, var questions) {
    showModalMenu(context, onQuestionsFile: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionsFlow(questions: questions),
        ),
      );
    }, onFlashcards: () {
      List<Flashcard> flashcards = generateFlashcards(questions);
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
              FeynmanFlow(questions: questions, currentQuestionIndex: 0),
        ),
      );
    }, onMatch: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Match(data: questions),
        ),
      );
    });
  }

  void _showNameChangeDialog(BuildContext context, QuestionsList questionList) {
    TextEditingController newNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Change Note Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Current name: ${questionList.name}'),
              const SizedBox(height: 10),
              TextField(
                controller: newNameController,
                decoration: const InputDecoration(
                  labelText: 'New name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      String newName = newNameController.text.trim();
                      if (newName.isNotEmpty) {
                        await dbHelper.updateName(questionList.name, newName);
                        setState(() {});
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
