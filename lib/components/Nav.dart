import 'package:flutter/material.dart';
import '../utils.dart';
import '../screens/note_image.dart';
import '../screens/generate_notes.dart';

PreferredSizeWidget? appBar(String title, BuildContext context) {
  return AppBar(
    title: Text(title,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
    centerTitle: true,
    backgroundColor: yellow,
    elevation: 0,
    actions: [
      Padding(
        padding:
            const EdgeInsets.only(right: 8.0), // Change the value as needed
        child: IconButton(
          icon: const Icon(Icons.edit, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GenerateNotes()),
            );
          },
        ),
      ),
      Padding(
        padding:
            const EdgeInsets.only(right: 8.0), // Change the value as needed
        child: IconButton(
          icon: const Icon(Icons.camera_alt_outlined,
              color: Colors.black, size: 30),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ImageToText()),
            );
          },
        ),
      ),
    ],
  );
}
