import 'dart:convert';
import 'package:e_mart/pages/bottom_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  final String? _baseUrl = dotenv.env['SERVER_URL'];

  Future<void> _loginUser() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        await _storage.write(key: 'token', value: responseData['token']);
        await _storage.write(key: 'userId', value: responseData['user']['userId']);

        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const bottomPage()),
        );
      } else {
        _showError(responseData['message'] ?? "Login failed");
      }
    } catch (e) {
      _showError(e is http.ClientException 
          ? "Network error. Check your connection"
          : "An error occurred");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const RegisterPage())),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Login', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Lottie.asset('asset/json_files/login.json', height: 250),
            _buildInputField('Email', _emailController),
            _buildInputField('Password', _passwordController, isPassword: true),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _loginUser,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        ),
      ),
    );
  }
}