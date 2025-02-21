import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/constants/text_string.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget child;
  const SplashScreen({super.key, required this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child),
              (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              height: 180,
              width: 180,
              image: AssetImage('asset/logos/shop_logo.png'),
            ),
            const SizedBox(height: GSizes.sm),
            Text(
              GText.splashScreenTitle1,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: GSizes.sm),
            Text(
              GText.splashScreenTitle2,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
