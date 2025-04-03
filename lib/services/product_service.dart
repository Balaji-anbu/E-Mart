import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../products/product_model.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;

  ProductService._internal();

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  List<Product> _products = [];
  bool _isFetched = false;

  Future<List<Product>> fetchProducts() async {
    if (_isFetched) return _products;

    try {
      // Retrieve the token from storage
      String? token = await _storage.read(key: 'token');

      if (token == null) {
        throw Exception('Authentication token is missing. Please log in.');
      }

      final response = await http.get(
        Uri.parse('https://e-mart-backend-authentication-production.up.railway.app/products'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Debug the response structure
        print('Server Response: $data');

        if (data != null && data['products'] is List) {
          _products = (data['products'] as List)
              .map((i) => Product.fromJson(i))
              .toList();
          _isFetched = true;
        } else {
          throw Exception('Invalid JSON structure: "products" key is missing or not a list');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized! Invalid or expired token.');
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products: $error');
      throw Exception('Error fetching products: $error');
    }

    return _products;
  }

  List<Product> get products => _products;
}
