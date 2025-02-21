import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String paymentId;

  const PaymentSuccessPage({required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text('Payment was successful!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text('Payment ID: $paymentId', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}