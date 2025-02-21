// payment_service.dart
import 'package:e_mart/pages/payment_failure_page.dart';
import 'package:e_mart/pages/payment_success_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay _razorpay;
  final BuildContext context;

  PaymentService(this.context) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(double totalAmount) {
    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb', // Replace with your Razorpay key
      'amount': (totalAmount * 100).toInt(), // Amount in paise
      'name': 'e-Mart',
      'description': 'Payment for your order',
      'prefill': {
        'contact': '9047190487',
        'email': 'test@razorpay.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessPage(paymentId: response.paymentId!),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentFailurePage(errorMessage: response.message!),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
    // Handle external wallet selection here
  }

  void dispose() {
    _razorpay.clear(); // Dispose of Razorpay instance when not in use
  }
}
