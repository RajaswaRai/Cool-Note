import 'package:cool_note/screens/cool_note.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Import your home page

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Developer's image (can be replaced with your own image)
            CircleAvatar(
              radius: 80,
              backgroundImage:
                  AssetImage('assets/awok.jpg'), // Add your image in assets
            ),
            SizedBox(height: 20),
            // Developer's name
            Text(
              'Developer', // Replace with your name
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'M. Rajaswa R. B.', // Replace with your name
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            // Funny text
            Text(
              'If you wish to use this app\ngive me your soul!', // Funny text
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoolNote(title: 'Cool Note'),
                  ),
                );
              },
              child: const Text('Press to sell your soul'),
            ),
          ],
        ),
      ),
    );
  }
}
