import 'package:flutter/material.dart';

import '../components/Nav.dart';

class Note extends StatefulWidget {
  final String title;
  const Note({super.key, required this.title});
  @override
  State<Note> createState() => _descriptionPageState();
}

class _descriptionPageState extends State<Note> {
  TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String notes = "";

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(backgroundColor: Color(0xff93BBF6));
    return Scaffold(
      appBar: nav(widget.title, context),
      backgroundColor: Color(0xffF6F8FE),
      body: Container(
        height:
            (MediaQuery.of(context).size.height - appBar.preferredSize.height),
        width: MediaQuery.of(context).size.width / 1.05,
        margin: EdgeInsets.all(15),
        child: Container(
            child: Card(
                elevation: 5,
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30,
                                )),
                            Text("",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    color: Colors.grey)),
                          ],
                        ),
                        const Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                        TextFormField(
                          controller: _notesController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 24,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your notes.',
                          ),
                          onChanged: (text) {
                            setState(() {
                              notes = text;
                            });
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6),
                      ],
                    )))),
      ),
    );
  }
}
