import '../../utils.dart';
import 'package:flutter/material.dart';

import '../../components/Nav.dart';
import '../../models/person.dart';
import 'home.dart';
import 'profile.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var w;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _graduationYearController =
      TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _graduationYearController.dispose();
    _aboutMeController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        title: Text("Edit Profile",
            style:
                TextStyle(color: Colors.grey[50], fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.grey[50]),
                ),
              )),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            subHeading("Profile picture link", true),
            buildField(_profileController, 'Profile Picture', true),
            subHeading("Full name", false),
            buildField(_nameController, 'Name', false),
            subHeading("Email", false),
            buildField(_emailController, 'Email', false),
            subHeading("About me", true),
            buildField(_aboutMeController, 'About Me', true),
          ],
        ),
      ),
    );
  }

  Widget subHeading(String sub, bool editable) {
    return Row(children: [
      Text(sub,
          style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.grey[700],
              fontSize: 13)),
      const SizedBox(width: 5),
      Icon(
        editable ? null : Icons.lock,
        size: 12,
        color: Colors.grey,
      )
    ]);
  }

  Widget buildField(TextEditingController t, String info, bool e) {
    String value = "";
    if (info == "Profile Picture") {
      value = fillerNetworkImage;
    } else if (info == "Name") {
      value = "Full name from db";
    } else if (info == "Email") {
      value = "Email from db";
    } else if (info == "About Me") {
      value = "About me from db";
    }
    t.text = value;

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 15),
      height: 25,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
      ),
      child: TextFormField(
        style: TextStyle(
          color: !e ? Colors.grey : Colors.black,
        ),
        enabled: e,
        controller: t,
        decoration: InputDecoration.collapsed(
          hintText: '$info',
          hintStyle: const TextStyle(fontSize: 16.0),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your ${info.toLowerCase()}';
          }
          return null;
        },
      ),
    );
  }
}
