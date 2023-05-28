import 'package:flutter/material.dart';
import 'package:makequiz/screens/home/home.dart';
import 'screens/home/addNew.dart';
import 'screens/home/profile.dart';
import 'screens/splash.dart';
import 'utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          primaryColor: Colors.red,
          textTheme: GoogleFonts.nunitoTextTheme(
            Theme.of(context).textTheme,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: redorange,
            foregroundColor: Colors.white
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        home: FutureBuilder<void>(
          future: _waitThreeSeconds(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Splash();
            } else {
              return Home();
            }
          },
        ));
  }

  Future<void> _waitThreeSeconds() async {
    await Future.delayed(Duration(seconds: 0));
  }
}
