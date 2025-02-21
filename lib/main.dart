import 'package:e_mart/pages/bottom_page.dart';
import 'package:e_mart/pages/cart_page.dart';
import 'package:e_mart/pages/checkout_page.dart';
import 'package:e_mart/pages/home_page.dart';
import 'package:e_mart/pages/splash_screen.dart';
import 'package:e_mart/pages/welcome/register_page.dart';
import 'package:e_mart/widgets/cart_model.dart';
import 'package:e_mart/widgets/wishlist_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Cart()),
          ChangeNotifierProvider(create: (context) => Wishlist()),
        ],
        child: myApp(), // Pass the service to MyApp
      ),
    );
}

class myApp extends StatelessWidget {
  const myApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(412, 915), // Design size from your design team
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (context) => SplashScreen(
                    child: RegisterPage(),
                  ),
              "cartpage": (context) => const CartPage(),
              "home": (context) => HomePage(),
              "checkoutpage": (context) => CheckoutPage(),
              "/bottomPage": (context) => bottomPage(),
            },
          );
        });
  }
}
//fee amanillah