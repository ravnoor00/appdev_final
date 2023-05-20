import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:makequiz/models/notes.dart';
import '../components/Nav.dart';

class Note extends StatefulWidget {
  final Notes note;
  const Note({super.key, required this.note});
  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final TextEditingController _notesController = TextEditingController();
  String notes = '';

  @override
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(backgroundColor: Color(0xff93BBF6));
    return Scaffold(
      appBar: nav(widget.note.name, context),
      backgroundColor: Color(0xffF6F8FE),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.list_view,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Add Note',
          ),
          SpeedDialChild(
            child: Icon(Icons.check),
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Delete Note',
          ),
        ],
      ),
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
                            Text(widget.note.name,
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
