import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
const String baseUrl = "http://192.168.1.6:5000"; // Change to your backend URL

/// **Register User**
Future<void> registerUser(String username, String email, String password) async {
  final response = await http.post(
    Uri.parse("$baseUrl/register"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "username": username,
      "email": email,
      "password": password
    }),
  );

  if (response.statusCode == 200) {
    print("✅ User registered successfully!");
  } else {
    print("❌ Error: ${response.body}");
  }
}

/// **Login User & Store JWT Token**
Future<void> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse("$baseUrl/login"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"email": email, "password": password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    await storage.write(key: "token", value: data["token"]); // Store JWT securely
    print("✅ Login successful!");
  } else {
    print("❌ Error: ${response.body}");
  }
}

/// **Get User Profile with JWT**
Future<void> getUserProfile() async {
  String? token = await storage.read(key: "token");

  final response = await http.get(
    Uri.parse("$baseUrl/profile"),
    headers: {
      "Authorization": token ?? "",
      "Content-Type": "application/json"
    },
  );

  if (response.statusCode == 200) {
    print("✅ User Profile: ${response.body}");
  } else {
    print("❌ Error: ${response.body}");
  }
}