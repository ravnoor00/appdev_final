import 'package:flutter/material.dart';

import '../firebase_helper.dart';
import '../utils.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              appName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            const CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/logo.png'),
            ), // Replace with your logo
            const SizedBox(height: 75),

            GestureDetector(
              onTap: () {
                Authentication.signInWithGoogle(context: context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/google.png', // Replace with your asset image path
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Continue with Google',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
