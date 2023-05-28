import 'package:flutter/material.dart';

import '../../utils.dart';

class Statistics extends StatefulWidget {
  final int numNotes;
  final int numDays;
  final int numCorrect;
  final int numIncorrect;

  const Statistics({
    super.key,
    required this.numNotes,
    required this.numDays,
    required this.numCorrect,
    required this.numIncorrect,
  });

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  String correctIncorrectRatio = "";

  @override
  void initState() {
    super.initState();
    if (widget.numIncorrect == 0) {
      correctIncorrectRatio = widget.numCorrect.toString();
    } else {
      correctIncorrectRatio =
          (widget.numCorrect / widget.numIncorrect).toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[50],
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            statItem(title: "Notes", value: widget.numNotes.toString()),
            statItem(title: "Days Studied", value: widget.numDays.toString()),
            statItem(title: "Accuracy", value: "${double.parse(correctIncorrectRatio).floor()}%"),
          ],
        ),
      ),
    );
  }

  Widget statItem({required String title, required String value}) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 15.0,
          ),
        ),
        const SizedBox(height: 5.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.orange[50], // Assuming this is the color you want
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(15),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.brown,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
