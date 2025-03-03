import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login_page.dart';
import 'phone_verification_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  final String? url = dotenv.env["SERVER_URL"];
  final _storage = const FlutterSecureStorage();
  Future<void> _loginUser() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("$url/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);
Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const PhoneVerificationPage()),
        );
      if (response.statusCode == 200) {
        await _storage.write(key: 'token', value: responseData['token']);
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

  Future<void> _registerUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError("Passwords do not match!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("$url/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        await _loginUser();
      } else {
        _showError(responseData['message'] ?? "Registration failed");
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const Text('Register', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Lottie.asset('asset/json_files/register.json', height: 250),
            _buildInputField('Username', _usernameController),
            _buildInputField('Email', _emailController),
            _buildInputField('Password', _passwordController, isPassword: true),
            _buildInputField('Confirm Password', _confirmPasswordController, isPassword: true),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
                  ),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const LoginPage())), 
              
              child: const Text('Already have an account? Login'),
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