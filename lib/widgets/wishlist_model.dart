import 'package:e_mart/products/product_model.dart';
import 'package:flutter/foundation.dart';

class WishlistItem {
  final Product product; // Reference to Product instead of duplicating fields

  WishlistItem({
    required this.product,
  });
}

class Wishlist with ChangeNotifier {
  final Map<String, WishlistItem> _items = {};

  Map<String, WishlistItem> get items {
    return {..._items};
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      // Item already exists in the wishlist
    } else {
      _items.putIfAbsent(
        product.id,
            () => WishlistItem(
          product: product,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }
}
