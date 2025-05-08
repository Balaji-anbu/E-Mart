// import 'package:e_mart/products/product_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class CartItem {
//   final Product product;
//   final int quantity;

//   CartItem({
//     required this.product,
//     required this.quantity,
//   });
// }

// final storage1 = FlutterSecureStorage();
// class Cart with ChangeNotifier {
//   final Map<String, CartItem> _items = {};

//   Map<String, CartItem> get items => _items;

//   int get itemCount {
//     int totalQuantity = 0;
//     _items.forEach((key, cartItem) {
//       totalQuantity += cartItem.quantity;
//     });
//     return totalQuantity;
//   }

//   double get totalAmount {
//     double total = 0.0;
//     _items.forEach((key, cartItem) {
//       total += cartItem.product.variants.first.mrp * cartItem.quantity;  // Example using price from ProductOption
//     });
//     return total;
//   }

//   // Updated method with better error handling and token formatting
//   Future<void> _syncWithServer(String productId, int quantity, double price) async {
//     try {
//       final token = await storage1.read(key: "token");
//       final userId = await storage1.read(key: "userId"); // Retrieve userId

//       // Debugging Logs
//       print('Retrieved token: $token');
//       print('Retrieved userId: $userId');

//       if (token == null || userId == null) {
//         print('User not authenticated. Cart changes will be stored locally only.');
//         return;
//       }

//       final url = dotenv.env['SERVER_URL'];
//       if (url == null || url.isEmpty) {
//         print('SERVER_URL environment variable is not set correctly.');
//         return;
//       }

//       print('Syncing cart with server: userId=$userId, productId=$productId, quantity=$quantity, price=$price');

//       final response = await http.post(
//         Uri.parse('$url/add-to-cart'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': token.startsWith('Bearer ') ? token : 'Bearer $token',
//         },
//         body: json.encode({
//           'userId': userId,
//           'productId': productId,
//           'quantity': quantity,
//           'price': price,
//         }),
//       );

//       print('Server response status: ${response.statusCode}');
//       if (response.statusCode != 200) {
//         print('Failed to sync cart with server: ${response.body}');
//       } else {
//         print('Cart synced successfully with server.');
//       }
//     } catch (error) {
//       print('Error syncing cart with server: $error');
//     }
//   }

//   // Method to check stored credentials for debugging
//   Future<void> checkStoredCredentials() async {
//     final storedToken = await storage1.read(key: "token");
//     final storedUserId = await storage1.read(key: "userId");

//     print("Stored Token: $storedToken");
//     print("Stored UserID: $storedUserId");
//   }

//   // Make the addItem method also sync removals with server when quantity is zero
//   void addItem(Product product, {int quantity = 1}) {
//     if (_items.containsKey(product.id)) {
//       _items.update(
//         product.id,
//         (existingCartItem) => CartItem(
//           product: product,
//           quantity: existingCartItem.quantity + quantity,
//         ),
//       );
//     } else {
//       _items.putIfAbsent(
//         product.id,
//         () => CartItem(
//           product: product,
//           quantity: quantity,
//         ),
//       );
//     }
//     notifyListeners();

//     // Call server API after updating local cart with product ID
//     _syncWithServer(
//       product.id,
//       _items[product.id]!.quantity,
//       product.variants.first.mrp,
//     );
//   }

//   void removeItem(String productId) {
//     if (_items.containsKey(productId)) {
//       // Get the price before removing the item
//       final price = _items[productId]!.product.variants.first.mrp;

//       _items.remove(productId);
//       notifyListeners();

//       // Sync with server that item was removed (quantity = 0)
//       _syncWithServer(productId, 0, price);
//     }
//   }

//   void updateQuantity(String productId, int newQuantity) {
//     if (_items.containsKey(productId)) {
//       if (newQuantity > 0) {
//         _items.update(
//           productId,
//           (existingCartItem) => CartItem(
//             product: existingCartItem.product,
//             quantity: newQuantity,
//           ),
//         );

//         // Sync updated quantity with server
//         _syncWithServer(
//           productId,
//           newQuantity,
//           _items[productId]!.product.variants.first.mrp,
//         );
//       } else {
//         // If quantity is 0 or negative, remove the item
//         removeItem(productId);
//       }
//       notifyListeners();
//     }
//   }

//   void clear() {
//     _items.clear();
//     notifyListeners();
//   }

//   // Method to retrieve the cart items from the server
//   Future<bool> fetchCartFromServer() async {
//     try {
//       final token = await storage1.read(key: "token");
//       final userId = await storage1.read(key: "userId");

//       if (token == null || userId == null) {
//         print('User not authenticated. Cart retrieval failed.');
//         return false;
//       }

//       final url = dotenv.env['SERVER_URL'];
//       if (url == null || url.isEmpty) {
//         print('SERVER_URL environment variable is not set correctly.');
//         return false;
//       }

//       final response = await http.get(
//         Uri.parse('$url/get-cart'),
//         headers: {
//           'Authorization': token.startsWith('Bearer ') ? token : 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final cartData = json.decode(response.body);
//         if (cartData['success']) {
//           final cartItems = cartData['carts']['items'] as List;
//           _items.clear();
//           for (var item in cartItems) {
//             try {
//               final product = Product.fromJson(item['productId']);
//               final quantity = item['quantity'];
//               _items[product.id] = CartItem(product: product, quantity: quantity);
//             } catch (e) {
//               print('Error parsing cart item: $e');
//             }
//           }
//           notifyListeners();
//           print('Cart retrieved and synced successfully.');
//           return true;
//         }
//       }
//       print('Failed to fetch cart from server: ${response.body}');
//       return false;
//     } catch (error) {
//       print('Error fetching cart from server: $error');
//       return false;
//     }
//   }
// }

// Future<void> storeUserCredentials(String token, String userId) async {
//   await storage1.write(key: "token", value: token);
//   await storage1.write(key: "userId", value: userId);
//   print("User credentials stored successfully.");
// }
import 'package:e_mart/products/product_model.dart';
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
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
      // Make sure to handle products with no variants
      if (cartItem.product.variants.isNotEmpty) {
        total += cartItem.product.variants.first.mrp * cartItem.quantity;
      }
    });
    return total;
  }

  // Updated method with better error handling and token formatting
  Future<bool> _syncWithServer(String productId, int quantity, double price) async {
    try {
      final token = await storage1.read(key: "token");
      final userId = await storage1.read(key: "userId");

      if (token == null || userId == null) {
        _errorMessage = 'User not authenticated. Please log in to sync your cart.';
        notifyListeners();
        return false;
      }

      final url = dotenv.env['SERVER_URL'];
      if (url == null || url.isEmpty) {
        _errorMessage = 'Server URL configuration error. Please contact support.';
        notifyListeners();
        return false;
      }

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

      if (response.statusCode == 200) {
        _errorMessage = null;
        return true;
      } else {
        _errorMessage = 'Failed to sync cart with server: ${response.body}';
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = 'Error syncing cart with server: $error';
      notifyListeners();
      return false;
    }
  }

  void addItem(Product product, {int quantity = 1}) {
    _isLoading = true;
    notifyListeners();

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
    
    _isLoading = false;
    notifyListeners();

    // Sync with server in the background
    if (product.variants.isNotEmpty) {
      _syncWithServer(
        product.id,
        _items[product.id]!.quantity,
        product.variants.first.mrp,
      );
    }
  }

  void removeItem(String productId) {
    _isLoading = true;
    notifyListeners();
    
    double price = 0;
    if (_items.containsKey(productId)) {
      // Get the price before removing the item
      if (_items[productId]!.product.variants.isNotEmpty) {
        price = _items[productId]!.product.variants.first.mrp;
      }

      _items.remove(productId);
      
      _isLoading = false;
      notifyListeners();

      // Sync with server that item was removed (quantity = 0)
      _syncWithServer(productId, 0, price);
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateQuantity(String productId, int newQuantity) {
    _isLoading = true;
    notifyListeners();
    
    if (_items.containsKey(productId)) {
      if (newQuantity > 0) {
        _items.update(
          productId,
          (existingCartItem) => CartItem(
            product: existingCartItem.product,
            quantity: newQuantity,
          ),
        );

        _isLoading = false;
        notifyListeners();

        // Sync updated quantity with server if product has variants
        if (_items[productId]!.product.variants.isNotEmpty) {
          _syncWithServer(
            productId,
            newQuantity,
            _items[productId]!.product.variants.first.mrp,
          );
        }
      } else {
        // If quantity is 0 or negative, remove the item
        removeItem(productId);
      }
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Improved method to retrieve the cart items from the server
  Future<bool> fetchCartFromServer() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final token = await storage1.read(key: "token");
      final userId = await storage1.read(key: "userId");

      if (token == null || userId == null) {
        _errorMessage = 'User not authenticated. Please log in to view your cart.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final url = dotenv.env['SERVER_URL'];
      if (url == null || url.isEmpty) {
        _errorMessage = 'Server URL configuration error. Please contact support.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('Fetching cart from server for user: $userId');
      
      // Make sure to use the correct endpoint as per your server API
      final response = await http.get(
        Uri.parse('$url/get-cart'),
        headers: {
          'Authorization': token.startsWith('Bearer ') ? token : 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Server response status: ${response.statusCode}');
      print('Response body: ${response.body.substring(0, min(100, response.body.length))}...');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Clear existing items before adding new ones
        _items.clear();
        
        // Parse the response according to your server's response structure
        // This structure should match exactly what your backend returns
        if (responseData['success'] == true) {
          final cartData = responseData['carts'];
          
          if (cartData != null && cartData['items'] != null) {
            final List cartItems = cartData['items'];
            print('Found ${cartItems.length} items in cart');
            
            for (var item in cartItems) {
              try {
                // Make sure item has the expected structure
                if (item['productId'] != null && item['quantity'] != null) {
                  // Get product data - this might need adjustment based on your API
                  final dynamic productData = item['productId'];
                  
                  // Create product from JSON - ensure this matches your Product model
                  final Product product = Product.fromJson(productData);
                  final int quantity = int.parse(item['quantity'].toString());
                  
                  print('Adding product to cart: ${product.title}, Qty: $quantity');
                  
                  // Add to cart items
                  _items[product.id] = CartItem(
                    product: product,
                    quantity: quantity,
                  );
                }
              } catch (e) {
                print('Error parsing cart item: $e');
                // Continue with next item instead of failing the whole operation
              }
            }
          } else {
            print('Cart data structure is not as expected: $cartData');
          }
          
          _isLoading = false;
          _errorMessage = null;
          notifyListeners();
          print('Cart fetched successfully, ${_items.length} items loaded');
          return true;
        } else {
          _errorMessage = responseData['message'] ?? 'Failed to fetch cart data';
          print('Error fetching cart: $_errorMessage');
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'Failed to fetch cart: ${response.statusCode} - ${response.reasonPhrase}';
        print('HTTP Error: $_errorMessage');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = 'Error fetching cart: $error';
      print('Exception fetching cart: $error');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Helper function to limit string length
  int min(int a, int b) {
    return a < b ? a : b;
  }
}

Future<void> storeUserCredentials(String token, String userId) async {
  await storage1.write(key: "token", value: token);
  await storage1.write(key: "userId", value: userId);
  print("User credentials stored successfully.");
}