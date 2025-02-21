import 'package:e_mart/widgets/product_model.dart';
import 'package:flutter/material.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });
}

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
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: newQuantity,
        ),
      );
      notifyListeners();
    }
  }
}
