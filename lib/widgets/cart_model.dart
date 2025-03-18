import 'package:e_mart/widgets/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });
}

final storage1 = FlutterSecureStorage();

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount {
    int totalQuantity = 0;
    _items.forEach((key, cartItem) {
      totalQuantity += cartItem.quantity;
    });
    return totalQuantity;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.options.first.price * cartItem.quantity;  // Example using price from ProductOption
    });
    return total;
  }

  // Updated method with better error handling and token formatting
  Future<void> _syncWithServer(String productId, int quantity, double price) async {
    try {
      final token = await storage1.read(key: "token");
      final userId = await storage1.read(key: "userId"); // Retrieve userId

      // Debugging Logs
      print('Retrieved token: $token');
      print('Retrieved userId: $userId');

      if (token == null || userId == null) {
        print('User not authenticated. Cart changes will be stored locally only.');
        return;
      }

      final url = dotenv.env['SERVER_URL'];
      if (url == null || url.isEmpty) {
        print('SERVER_URL environment variable is not set correctly.');
        return;
      }

      print('Syncing cart with server: userId=$userId, productId=$productId, quantity=$quantity, price=$price');

      final response = await http.post(
        Uri.parse('$url/add-to-cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.startsWith('Bearer ') ? token : 'Bearer $token',
        },
        body: json.encode({
          'userId': userId,
          'productId': productId,
          'quantity': quantity,
          'price': price,
        }),
      );

      print('Server response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('Failed to sync cart with server: ${response.body}');
      } else {
        print('Cart synced successfully with server.');
      }
    } catch (error) {
      print('Error syncing cart with server: $error');
    }
  }

  // Method to check stored credentials for debugging
  Future<void> checkStoredCredentials() async {
    final storedToken = await storage1.read(key: "token");
    final storedUserId = await storage1.read(key: "userId");

    print("Stored Token: $storedToken");
    print("Stored UserID: $storedUserId");
  }

  // Make the addItem method also sync removals with server when quantity is zero
  void addItem(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingCartItem) => CartItem(
          product: product,
          quantity: existingCartItem.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          product: product,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();

    // Call server API after updating local cart with product ID
    _syncWithServer(
      product.id,
      _items[product.id]!.quantity,
      product.options.first.price,
    );
  }

  void removeItem(String productId) {
    if (_items.containsKey(productId)) {
      // Get the price before removing the item
      final price = _items[productId]!.product.options.first.price;

      _items.remove(productId);
      notifyListeners();

      // Sync with server that item was removed (quantity = 0)
      _syncWithServer(productId, 0, price);
    }
  }

  void updateQuantity(String productId, int newQuantity) {
    if (_items.containsKey(productId)) {
      if (newQuantity > 0) {
        _items.update(
          productId,
          (existingCartItem) => CartItem(
            product: existingCartItem.product,
            quantity: newQuantity,
          ),
        );

        // Sync updated quantity with server
        _syncWithServer(
          productId,
          newQuantity,
          _items[productId]!.product.options.first.price,
        );
      } else {
        // If quantity is 0 or negative, remove the item
        removeItem(productId);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Method to retrieve the cart items from the server
  Future<bool> fetchCartFromServer() async {
    try {
      final token = await storage1.read(key: "token");
      final userId = await storage1.read(key: "userId");

      if (token == null || userId == null) {
        print('User not authenticated. Cart retrieval failed.');
        return false;
      }

      final url = dotenv.env['SERVER_URL'];
      if (url == null || url.isEmpty) {
        print('SERVER_URL environment variable is not set correctly.');
        return false;
      }

      final response = await http.get(
        Uri.parse('$url/get-cart'),
        headers: {
          'Authorization': token.startsWith('Bearer ') ? token : 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final cartData = json.decode(response.body);
        if (cartData['success']) {
          final cartItems = cartData['carts']['items'] as List;
          _items.clear();
          for (var item in cartItems) {
            try {
              final product = Product.fromJson(item['productId']);
              final quantity = item['quantity'];
              _items[product.id] = CartItem(product: product, quantity: quantity);
            } catch (e) {
              print('Error parsing cart item: $e');
            }
          }
          notifyListeners();
          print('Cart retrieved and synced successfully.');
          return true;
        }
      }
      print('Failed to fetch cart from server: ${response.body}');
      return false;
    } catch (error) {
      print('Error fetching cart from server: $error');
      return false;
    }
  }
}

Future<void> storeUserCredentials(String token, String userId) async {
  await storage1.write(key: "token", value: token);
  await storage1.write(key: "userId", value: userId);
  print("User credentials stored successfully.");
}
