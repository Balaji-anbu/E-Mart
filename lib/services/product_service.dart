import 'dart:convert';
import 'package:http/http.dart' as http;
import '../products/product_model.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;

  ProductService._internal();

  List<Product> _products = [];
  bool _isFetched = false;

  Future<List<Product>> fetchProducts() async {
    if (_isFetched) return _products;

    try {
      final response = await http.get(Uri.parse('https://productfetcher-production-6da4.up.railway.app/products'));

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
