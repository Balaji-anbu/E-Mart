class ProductOption {
  final String quantity;
  final double price;

  ProductOption({
    required this.quantity,
    required this.price,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final String category; // Added field
  final List<String> images;
  final List<ProductOption> options;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category, // Added field
    required this.images,
    required this.options,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'], // Added field
      images: List<String>.from(json['images']),
      options: (json['options'] as List)
          .map((option) => ProductOption.fromJson(option))
          .toList(),
    );
  }
}
