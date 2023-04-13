import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:makequiz/screens/home.dart';
import 'firebase_options.dart';
import 'screens/note_image.dart';
import 'screens/profile.dart';
import 'utils.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('It worked');
  } catch (e) {
    print(e);
  }
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
