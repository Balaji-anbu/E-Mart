import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/widgets/home_app_bar.dart';
import 'package:e_mart/widgets/image_carousel.dart';
import 'package:e_mart/widgets/popular_categories.dart';
import 'package:e_mart/products/product_cards.dart';
import 'package:e_mart/widgets/top_drawer.dart';
import 'package:flutter/material.dart';
import 'package:e_mart/products/product_model.dart';
import 'package:lottie/lottie.dart';
import 'package:e_mart/services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService().fetchProducts();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  Map<String, List<Product>> _groupProductsByCategory(List<Product> products) {
    final Map<String, List<Product>> groupedProducts = {};
    for (var product in products) {
      groupedProducts.putIfAbsent(product.category, () => []).add(product);
    }
    return groupedProducts;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppBar(),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset("asset/json_files/loading.json"));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          }

          final products = snapshot.data!;
          final groupedProducts = _groupProductsByCategory(products);

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Popular categories
                const PopularCategories(),

                // Image carousel
                ImageCarousel(),

                // Display products grouped by category
                ...groupedProducts.entries.map((entry) {
                  final category = entry.key;
                  final categoryProducts = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: GColors.textPrimary,
                          ),
                        ),
                      ),
                      ProductCards(product: categoryProducts),
                    ],
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),

      // Floating arrow button
      floatingActionButton: _scrollController.hasClients && _scrollController.offset > 100
          ? FloatingActionButton(
              backgroundColor: GColors.secondary,
              foregroundColor: GColors.white,
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            )
          : null,

      // Drawer
      endDrawer: const TopDrawer(),
    );
  }
}
