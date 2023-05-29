import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makequiz/models/flashcard.dart';
import 'package:makequiz/screens/home/addNew.dart';
import 'package:makequiz/screens/home/helpCenter.dart';
import 'package:makequiz/screens/studyOptions/testYourself/testYourselfInstructions.dart';
import '../studyOptions/flashcards/flashcardInstructions.dart';
import 'search.dart';
import '../../components/Home/Statistics.dart';
import '../../components/HorizontalQuizCard.dart';
import '../../models/notes.dart';
import '../../models/person.dart';
import '../note.dart';
import 'profile.dart';
import '../studyOptions/match/matchInstructions.dart';
import '../studyOptions/feynman/feynmanInstructions.dart';
import '../../components/Nav.dart';
import '../../components/StudyOptions.dart';
import '../../utils.dart';
import '../../models/question.dart';
import '../../database_helper.dart';
import '../studyOptions/flashcards/flashcards.dart';
import '../../components/togglebuttons.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

bool isLoaded = false;
int _selectedIndex = 0;

class _Home extends State<Home> {
  var width;
  late DatabaseHelper dbHelper;
  int _selectedButtonIndex = 0;
  String _title = "Home";

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
    List<Widget> widgetOptions = [
      home(),
      const Search(),
      const AddNew(),
      Profile(
        editable: true,
        person: Person(
            name: "Full name",
            email: "Email",
            aboutMe: "About me",
            imageURL: fillerNetworkImage),
      ),
      const HelpCenter()
    ];
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: nav(_title, context),
        body: widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.grey[800],
          currentIndex: _selectedIndex,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Home"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded), label: "Search"),
            BottomNavigationBarItem(
              icon: IconTheme(
                data: IconThemeData(
                  color: redorange,
                  size: 36, // Adjust the size to your preference
                ),
                child: Transform.translate(
                  offset: Offset(
                      0, 8), // Adjust the vertical offset to center the icon
                  child: Icon(Icons.add_circle),
                ),
              ),
              label: "", // Set an empty label to hide the label
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_pin_circle_rounded),
              label: "Profile",
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.help), label: "Help Center"),
          ],
        ));
  }

  Widget home() {
    return SingleChildScrollView(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 15),
        heading(),
        const SizedBox(height: 30),
        const Text("Progress",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const Statistics(
            numNotes: 11, numDays: 7, numCorrect: 52, numIncorrect: 2),
        const SizedBox(height: 25),
        const Text("Notes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 10),
        _fetchData(),
        const SizedBox(height: 25),
        const Text("Quizzes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 10),
        _quizCards(),
        const SizedBox(height: 25),
      ]),
    ));
  }

  Widget heading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome back Ravnoor Bedi 👋",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800])),
        const SizedBox(height: 10),
        const Text(
            "Quote of the day: Today is a good day to learn something new!",
            style: TextStyle(color: Colors.grey))
      ],
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
            return const Text('Scan your notes',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600));
          }
          return noteCards(snapshot.data!);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _quizCards() {
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
            return const Text('Scan your notes',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600));
          }
          return QCards(snapshot.data!);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget QCard(QuestionsList questionList) {
    return GestureDetector(
      onTap: () {
      _showBottomModal(questionList);
    },
    child: HorizontalQuizCard(description: questionList.topic, title: questionList.name, questions: questionList, numOfQuestions: questionList.questions.length,));
  }


  Widget QCards(List<QuestionsList> data) {
    List<Widget> QCardWidgets =
        data.map((questionList) => QCard(questionList)).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: QCardWidgets),
    );
  }



  void _showBottomModal(QuestionsList questions) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.library_books_rounded),
                title: const Text('Flashcards'),
                onTap: () {
                  Navigator.pop(context);
                  navigate(
                      FlashcardInstructions(questions: questions), context);
                },
              ),
              ListTile(
                leading: Icon(Icons.text_snippet_rounded),
                title: const Text('Test'),
                onTap: () {
                  Navigator.pop(context);
                  navigate(TestInstructions(question: questions), context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Feynman'),
                onTap: () {
                  Navigator.pop(context);
                  navigate(
                      FeynmanInstructions(
                        questions: questions,
                      ),
                      context);
                },
              ),
              ListTile(
                leading: Icon(Icons.headset),
                title: Text('Match'),
                onTap: () {
                  Navigator.pop(context);
                  navigate(
                      MatchInstructions(
                        question: questions,
                      ),
                      context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buttons() {
    return isLoaded == true
        ? Row(
            children: List.generate(
            topics.length,
            (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

  Widget noteCard(QuestionsList questionList) {
    return GestureDetector(
      onTap: () {
        navigate(
            Note(
                note: Notes(
              questions: questionList,
              notes: "lorem ipsum",
              topic: questionList.topic,
              name: questionList.name,
            )),
            context);
      },
      child: Container(
        width: 150,
        height: 224,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 25, top: 5),
                          child: Text(questionList.name,
                              style: TextStyle(fontWeight: FontWeight.w600))),
                      // const SizedBox(height: 20),
                      Column(
                        children: List<Widget>.generate(
                          12,
                          (index) => Divider(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 15, // Position of the red margin line
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      color: Colors.red[200],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  

  Widget noteCards(List<QuestionsList> data) {
    List<Widget> noteCardWidgets =
        data.map((questionList) => noteCard(questionList)).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: noteCardWidgets),
    );
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _title = "Home";
          break;
        case 1:
          _title = "Search";
          break;
        case 2:
          _title = "New Note";
          break;
        case 3:
          _title = "Profile";
          break;
        case 4:
          _title = "Help Center";
          break;
      }
    });
  }

  // Widget noteCard2(QuestionsList questionList) {
  //   return InkWell(
  //     onTap: () {},
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 10),
  //       height: 225,
  //       width: 150,
  //       child: Card(
  //         elevation: 3,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           side: const BorderSide(color: Colors.black, width: 1),
  //         ),
  //         child: Stack(
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.all(15),
  //               child: Text(
  //                 questionList.name,
  //                 style: const TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             ListView.separated(
  //               padding:
  //                   EdgeInsets.only(right: 50), // Provide space for IconButton
  //               itemCount: 20,
  //               separatorBuilder: (BuildContext context, int index) =>
  //                   const Divider(color: Color.fromARGB(255, 32, 32, 32)),
  //               itemBuilder: (BuildContext context, int index) =>
  //                   Container(), // Empty container as item
  //             ),
  //             Row(
  //               children: [
  //                 const SizedBox(width: 15),
  //                 Container(
  //                   width: 2,
  //                   color: Colors.red[200],
  //                 ),
  //                 Expanded(
  //                   child: Column(
  //                     mainAxisSize:
  //                         MainAxisSize.min, // limit the size to its content
  //                     children: [
  //                       const SizedBox(height: 5),
  //                       const SizedBox(height: 30),
  //                       IconButton(
  //                         icon: const Icon(Icons.more_horiz),
  //                         onPressed: () {
  //                           showCupertinoModalPopup(
  //                             context: context,
  //                             builder: (context) => CupertinoActionSheet(
  //                               actions: [
  //                                 CupertinoDialogAction(
  //                                   child: const Text('Delete Note'),
  //                                   onPressed: () async {
  //                                     await dbHelper
  //                                         .deleteRow(questionList.name);
  //                                     setState(() {
  //                                       isLoaded = false;
  //                                     });
  //                                     Navigator.of(context).pop();
  //                                   },
  //                                 ),
  //                                 CupertinoDialogAction(
  //                                   child: const Text('Change Name'),
  //                                   onPressed: () {
  //                                     Navigator.of(context).pop();
  //                                     _showNameChangeDialog(
  //                                         context, questionList);
  //                                   },
  //                                 ),
  //                               ],
  //                               cancelButton: CupertinoDialogAction(
  //                                 child: const Text('Cancel'),
  //                                 onPressed: () {
  //                                   Navigator.of(context).pop();
  //                                 },
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
