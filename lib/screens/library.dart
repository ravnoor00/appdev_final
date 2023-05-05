import 'package:flutter/material.dart';

import '../components/Nav.dart';

class HeaderItem {
  final Icon icon;
  final String text;
  final String number;
  final Color? color;

  HeaderItem(
      {required this.icon,
      required this.text,
      required this.number,
      required this.color});
}

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  var headerItems = [
    HeaderItem(
        icon: Icon(Icons.star),
        text: "Starred",
        number: "7",
        color: Colors.blue[700]!),
    HeaderItem(
        icon: Icon(Icons.archive),
        text: "Archive",
        number: "7",
        color: Colors.yellow[700]!),
    HeaderItem(
        icon: Icon(Icons.garage),
        text: "Trash",
        number: "7",
        color: Colors.red[700]!),
    HeaderItem(
        icon: Icon(Icons.notifications),
        text: "Notifications",
        number: "7",
        color: Colors.grey[700]!),
    HeaderItem(
        icon: Icon(Icons.settings),
        text: "Settings",
        number: "7",
        color: Colors.grey[400]!),
  ];

  var noteItems = [
    HeaderItem(
        icon: Icon(Icons.book),
        text: "Intro to CS",
        number: "7",
        color: Colors.grey[500]!),
    HeaderItem(
        icon: Icon(Icons.book),
        text: "CS for nerds",
        number: "7",
        color: Colors.grey[500]),
    HeaderItem(
        icon: Icon(Icons.book),
        text: "how to git",
        number: "7",
        color: Colors.grey[500]),
    HeaderItem(
        icon: Icon(Icons.book),
        text: "hi",
        number: "7",
        color: Colors.grey[500]),
    HeaderItem(
        icon: Icon(Icons.book),
        text: "notes",
        number: "7",
        color: Colors.grey[500]),
  ];

  Widget buildItem(HeaderItem item) {
    return GestureDetector(
      onTap:() {
      },
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                item.icon,
                const SizedBox(width: 5),
                Text(item.text),
                const SizedBox(width: 5),
                Text(item.number),
              ],
            ),
            const Divider(color: Colors.grey, thickness: 0.2)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...headerItems.map((item) => buildItem(item)).toList(),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        ...noteItems.map((item) => buildItem(item)).toList(),
      ],
    );
  }
}
