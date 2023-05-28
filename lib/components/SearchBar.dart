import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBar();
}

TextEditingController t1 = TextEditingController();

class _SearchBar extends State<SearchBar> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: t1,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 22, horizontal: 22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey[100]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey[50]!),
              ),
              labelText: 'Search for notes, flashcards, quizzes',
              labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              suffixIcon: const Icon(Icons.search),
              floatingLabelBehavior:
                  FloatingLabelBehavior.never, // Remove the animation
            ),
            onChanged: (text) {
              setState(() => search = text.toLowerCase());
            },
          ),
        ],
      ),
    );
  }
}