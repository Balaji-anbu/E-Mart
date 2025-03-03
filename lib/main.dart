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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage1 = FlutterSecureStorage();
final String baseUrl = "https://e-mart-backend-authentication-production.up.railway.app";// Change to your backend URL

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Wishlist()),
      ],
      child: const MyApp(),
    ),
  );
}

/// **AuthCheck - Checks if User is Logged In**
class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool isLoading = true;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    checkUserAuth();
  }

  Future<void> checkUserAuth() async {
    String? token = await storage1.read(key: "token");
    
    if (token != null && token.isNotEmpty) {
      final response = await http.get(
        Uri.parse("$baseUrl/profile"),
        headers: {
          "Authorization": token,
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isAuthenticated = true;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return  Scaffold(body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("asset/json_files/loading.json"),
          SizedBox(height: 10),
          const Text("Loading Your Data..."),
        ],
      ));
    }
    return isAuthenticated ? const bottomPage() : RegisterPage();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 915), // Design size from your design team
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => const SplashScreen(child: AuthCheck()), // Use AuthCheck here
            "cartpage": (context) => const CartPage(),
            "home": (context) => const HomePage(),
            "checkoutpage": (context) =>  CheckoutPage(),
            "/bottomPage": (context) => bottomPage(),
          },
        );
      },
    );
  }
}
