import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:e_mart/components/product_badge.dart';

class ProductVariant {
  final String sku;
  final double dealerPrice;
  final double? specialPrice;
  final double mrp;
  final String imageUrl;
  final bool inStock;

  ProductVariant({
    required this.sku,
    required this.dealerPrice,
    this.specialPrice,
    required this.mrp,
    required this.imageUrl,
    required this.inStock,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      sku: json['SKU'] ?? '',
      dealerPrice: (json['dealerPrice'] ?? 0).toDouble(),
      specialPrice: json['specialPrice']?.toDouble(),
      mrp: (json['MRP'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      inStock: json['inStock'] ?? true,
    );
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductVariant> variants;
  final BadgeType badgeType;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.variants,
    this.badgeType = BadgeType.none,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['productId'] ?? '',
      title: json['productName'] ?? 'Unknown Product',
      description: json['description'] ?? 'No description available',
      category: json['category'] ?? 'Uncategorized',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      variants: (json['variants'] as List?)
          ?.map((v) => ProductVariant.fromJson(v))
          .toList() ?? [],
      badgeType: _getBadgeType(json['badge'] ?? ''),
    );
  }

  static BadgeType _getBadgeType(String badge) {
    switch (badge.toLowerCase()) {
      case 'trending':
        return BadgeType.trending;
      case 'bestseller':
        return BadgeType.bestSeller;
      default:
        return BadgeType.none;
    }
  }

  Future<List<String>> downloadImages() async {
    if (variants.isEmpty) return [];

    final List<String> localPaths = [];
    final directory = await getApplicationDocumentsDirectory();

    for (var variant in variants) {
      if (variant.imageUrl.isEmpty) continue;

      final fileName = variant.imageUrl.split('/').last;
      final localPath = '${directory.path}/$fileName';
      final file = File(localPath);

      // Check if the file exists and is a valid image
      if (!file.existsSync() || file.lengthSync() == 0 || !(await _isValidImage(file))) {
        try {
          final dio = Dio();
          await dio.download(variant.imageUrl, localPath);
          print('Downloaded image: $localPath');
        } catch (e) {
          print('Error downloading image: $e');
          continue;
        }
      }

      // Add the file path only if the file is valid
      if (file.existsSync() && file.lengthSync() > 0 && await _isValidImage(file)) {
        localPaths.add(localPath);
      } else {
        print('File is invalid or corrupted: $localPath');
      }
    }

    return localPaths;
  }

  // Helper method to validate if a file is a valid image
  Future<bool> _isValidImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final codec = await instantiateImageCodec(bytes);
      await codec.getNextFrame(); // Decode the first frame to validate
      return true;
    } catch (e) {
      print('Invalid image file: ${file.path}, Error: $e');
      return false;
    }
  }

  // Helper method to get the best price
  double get bestPrice {
    if (variants.isEmpty) return 0.0;
    var variant = variants.first;
    return variant.specialPrice ?? variant.mrp;
  }

  // Get all images URLs from variants
  List<String> get imageUrls => variants.map((v) => v.imageUrl).where((url) => url.isNotEmpty).toList();
}
