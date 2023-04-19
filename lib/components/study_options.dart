
import 'package:flutter/cupertino.dart';

Future<void> showModalMenu(BuildContext context,
    {required VoidCallback onQuestionsFile, required VoidCallback onFlashcards, required VoidCallback onFeynman, required VoidCallback onMatch}) async {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: const Text('Ways to Study'),
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
        CupertinoActionSheetAction(
          onPressed: onMatch,
          child: const Text("Matching's Technique"),
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
