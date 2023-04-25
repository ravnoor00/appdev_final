import 'package:flutter/material.dart';

String appName = "Study App";

Color yellow = const Color(0xffFFFCF2);
Color redorange = const Color(0xffEB5E27);
Color textField = const Color(0xffF2EDDF);

void navigate(BuildContext context, Widget w) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => w),
  );
}