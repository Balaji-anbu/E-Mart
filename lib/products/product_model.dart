class ProductOption {
  final String quantity;
  final double price;

  ProductOption({
    required this.quantity,
    required this.price,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      quantity: json['quantity'] ?? '0', // Default to '0' if null
      price: (json['price'] ?? 0).toDouble(), // Default to 0 if null
    );
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> images;
  final List<ProductOption> options;
  final String price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.images,
    required this.options,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['productId'] ?? '', // Default to empty string if null
      title: json['productName'] ?? 'Unknown Product', // Default to placeholder if null
      description: json['SKU'] ?? 'No description available', // Default to placeholder if null
      category: json['category'] ?? 'Uncategorized', // Default to placeholder if null
      price: json['price'] ?? '0', // Default to '0' if null
      images: (json['imageUrl'] as List?)?.map((e) => e.toString()).toList() ?? [], // Default to empty list if null
      options: (json['options'] as List?)
              ?.map((option) => ProductOption.fromJson(option))
              .toList() ??
          [], // Default to empty list if null
    );
  }
}
