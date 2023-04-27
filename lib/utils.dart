import 'package:flutter/material.dart';

String appName = "Study App";

Color yellow = Color.fromARGB(255, 247, 242, 227);
Color redorange = const Color(0xffEB5E27);
Color textField = const Color(0xffF2EDDF);

void navigate(BuildContext context, Widget w) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => w),
  );
}