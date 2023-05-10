import 'package:flutter/material.dart';

import '../utils.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
             const CircleAvatar(
              radius: 110,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            SizedBox(height: 75),
            Text(
              appName,
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
