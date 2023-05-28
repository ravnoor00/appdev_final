import 'package:flutter/material.dart';
import 'package:makequiz/components/FlashCard.dart';
import 'package:makequiz/models/flashcard.dart';
import 'package:makequiz/utils.dart';
import '../../../components/Nav.dart';
import '../../home/home.dart';

class Flashcards extends StatefulWidget {
  final List<Flashcard> flashcards;

  const Flashcards({super.key, required this.flashcards});

  @override
  State<Flashcards> createState() => _FlashcardTest();
}

class _FlashcardTest extends State<Flashcards> {
  int _selectedIndex = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _selectedIndex = _pageController.page!.round() + 1;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: nav("Flashcards", context),

      // AppBar(
      //     elevation: 0,
      //     backgroundColor: yellow,
      //     title: Text(
      //       '$_selectedIndex/${widget.flashcards.length}',
      //       style: const TextStyle(
      //         color: Colors.black,
      //       ),
      //     ),
      //     leading: IconButton(
      //         onPressed: () => Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (BuildContext context) => const Home()),
      //             ),
      //         icon: const Icon(Icons.home, color: Colors.black, size: 30))),

      body: PageView.builder(
        itemCount: widget.flashcards.length,
        itemBuilder: (BuildContext context, int index) {
          final flashcardhere = widget.flashcards[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlashCard(
                  flashcard: Flashcard(
                      frontText: flashcardhere.frontText,
                      backText: flashcardhere.backText),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$_selectedIndex/${widget.flashcards.length}',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          );
        },
        controller: _pageController,
      ),
    );
  }
}
