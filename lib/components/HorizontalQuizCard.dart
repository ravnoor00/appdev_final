import 'package:flutter/material.dart';

import '../utils.dart';

class HorizontalQuizCard extends StatelessWidget {
  final String title;
  final String description;
  final int numOfQuestions;

  const HorizontalQuizCard({
    required this.title,
    required this.description,
    required this.numOfQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey, width: 1),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(20),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(description),
          trailing: Chip(
            backgroundColor: redorange,
            label: Text(
              '$numOfQuestions Questions',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
