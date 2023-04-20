import 'package:flutter/material.dart';

class HeaderItem {
  final Icon icon;
  final String text;
  final String number;

  HeaderItem({required this.icon, required this.text, required this.number});
}

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  var headerItems = [
    HeaderItem(icon: Icon(Icons.star), text: "Starred", number: "7"),
    HeaderItem(icon: Icon(Icons.archive), text: "Archive", number: "7"),
    HeaderItem(icon: Icon(Icons.garage), text: "Trash", number: "7"),
    HeaderItem(icon: Icon(Icons.notifications), text: "Notifications", number: "7"),
    HeaderItem(icon: Icon(Icons.settings), text: "Settings", number: "7"),
  ];

  var noteItems = [
    HeaderItem(icon: Icon(Icons.book), text: "Intro to CS", number: "7"),
    HeaderItem(icon: Icon(Icons.book), text: "CS for nerds", number: "7"),
    HeaderItem(icon: Icon(Icons.book), text: "how to git", number: "7"),
    HeaderItem(icon: Icon(Icons.book), text: "hi", number: "7"),
    HeaderItem(icon: Icon(Icons.book), text: "notes", number: "7"),
  ];

  Widget buildItem(HeaderItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        item.icon,
        const SizedBox(width: 5),
        Text(item.text),
        const SizedBox(width: 5),
        Text(item.number),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...headerItems.map((item) => buildItem(item)).toList(),
        Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        ...noteItems.map((item) => buildItem(item)).toList(),
      ],
    );
  }
}
