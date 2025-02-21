import 'package:e_mart/pages/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GreetingPage extends StatelessWidget {
  const GreetingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            LottieBuilder.asset(
              'asset/json_files/welcome_greeting.json',
              height: 290,
            ),
            SizedBox(
              height: 35,
            ),
            const Text(
              'Hello, Welcome!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Hello, Welcome!',
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              'Hello, Welcome!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                      (route) => false,
                );
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
