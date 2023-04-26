
import 'package:flutter/material.dart';
import 'package:makequiz/screens/home.dart';
import 'screens/note_image.dart';
import 'screens/profile.dart';
import 'utils.dart';
import 'package:path_provider/path_provider.dart';


main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellow,
      body: const Home(),
    );
  }
}
