
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showModalMenu(BuildContext context,
    {required VoidCallback onQuestionsFile, required VoidCallback onFlashcards, required VoidCallback onFeynman}) async {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: const Text('Choose action'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: onQuestionsFile,
          child: const Text('Text Yourself'),
        ),
        CupertinoActionSheetAction(
          onPressed: onFlashcards,
          child: const Text('Flashcards'),
        ),
         CupertinoActionSheetAction(
          onPressed: onFeynman,
          child: const Text("Feynman's Technique"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}
