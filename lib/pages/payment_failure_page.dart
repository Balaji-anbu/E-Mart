import 'package:flutter/material.dart';

class PaymentFailurePage extends StatelessWidget {
  final String errorMessage;

  const PaymentFailurePage({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Failure'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 100),
            const SizedBox(height: 20),
            const Text('Payment failed!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text('Error: $errorMessage', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}