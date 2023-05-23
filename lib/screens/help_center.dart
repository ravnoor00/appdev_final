import 'package:flutter/material.dart';

import '../components/Nav.dart';
import '../utils.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: nav("Help Center", context),
      drawer: sidebar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'How to use the app',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Here are some instructions to get you started...',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Email: support@example.com',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Phone: +1 800 123 4567',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.mail),
                label: Text('Contact support'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: redorange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
