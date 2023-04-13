import 'package:flutter/material.dart';
import 'package:makequiz/components/flash_card.dart';
import 'package:makequiz/models/flashcard.dart';
import 'package:makequiz/utils.dart';
import 'home.dart';

class FlashcardTest extends StatefulWidget {
  final List<Flashcard> flashcards;

  const FlashcardTest({super.key, required this.flashcards});

  @override
  State<FlashcardTest> createState() => _FlashcardTest();
}

class _FlashcardTest extends State<FlashcardTest> {
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
      backgroundColor: yellow,
      appBar: AppBar(
        backgroundColor: yellow,
          title: Text('$_selectedIndex/${widget.flashcards.length}'),
          leading: IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  ),
              icon: const Icon(Icons.home))),
      body: PageView.builder(
        itemCount: widget.flashcards.length,
        itemBuilder: (BuildContext context, int index) {
          final flashcardhere = widget.flashcards[index];
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlipCard(
                flashcard: Flashcard(
                    frontText: flashcardhere.frontText,
                    backText: flashcardhere.backText),
              ),
            ),
          );
        },
        controller: _pageController,
      ),
    );
  }
}
