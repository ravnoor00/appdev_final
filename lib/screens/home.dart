import 'package:flutter/material.dart';
import '../components/Nav.dart';
import 'note_image.dart';
import 'profile.dart';
import '../utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var w;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: yellow,
        appBar: appBar("Hello, Ravnoor"),
        body: Container(
          margin: EdgeInsets.all(25),
          child: Column(
              children: [heading(), const SizedBox(height: 50), noteCards()]),
        ));
  }

  Widget heading() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text("My Questions",
          style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800])),
    );
  }

  Widget noteCards() {
    List<Widget> noteCardWidgets = [];
    for (int i = 0; i < 10; i++) {
      noteCardWidgets.add(noteCard("AP Biology"));
    }

    int crossAxisCount = (w / 450).ceil();
    return Expanded(
        child: GridView.count(
      childAspectRatio: 0.75,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      crossAxisCount: crossAxisCount,
      children: noteCardWidgets,
    ));
  }

  Widget noteCard(String subject) {
    return Column(children: [
      Card(
        elevation: 3,
        child: Column(
          children: [
            const SizedBox(height: 30),
            ...List.generate(
              28,
              (index) => Divider(color: Colors.grey, height: 10),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Text(subject),
      const SizedBox(height: 15),
    ]);
  }
}
