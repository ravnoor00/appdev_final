import 'package:flutter/material.dart';
import 'package:makequiz/screens/home.dart';
import 'screens/note_image.dart';
import 'screens/profile.dart';
import 'screens/splash.dart';
import 'utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'firebase_options.dart';
import 'dart:async';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
            primaryColor: bgColor,
            textTheme: GoogleFonts.latoTextTheme(
              Theme.of(context).textTheme,
            )),
        home: FutureBuilder<void>(
            future: _waitThreeSeconds(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Splash();
              } else {
                return Home();
              }
            }));
  }

  Future<void> _waitThreeSeconds() async {
    await Future.delayed(Duration(seconds: 3));
  }
}
