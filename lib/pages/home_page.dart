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
import 'package:e_mart/products/horizontal_product_cards.dart';

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

  List<List<Product>> _splitProductsIntoChunks(List<Product> products, int chunkSize) {
    List<List<Product>> chunks = [];
    for (var i = 0; i < products.length; i += chunkSize) {
      chunks.add(
        products.sublist(
          i,
          i + chunkSize > products.length ? products.length : i + chunkSize,
        ),
      );
    }
    return chunks;
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
            return Center(child: Lottie.asset("asset/json_files/product_load.json"));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          }

          final products = snapshot.data!;
          final productChunks = _splitProductsIntoChunks(products, 20);

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const PopularCategories(),
                ImageCarousel(),
                ...List.generate(productChunks.length, (index) {
                  // Alternate between grid and horizontal layouts
                  if (index % 2 == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'Featured Products ${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: GColors.textPrimary,
                            ),
                          ),
                        ),
                        ProductCards(product: productChunks[index]),
                      ],
                    );
                  } else {
                    return HorizontalProductCards(product: productChunks[index]);
                  }
                }),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _scrollController.hasClients && _scrollController.offset > 100
          ? FloatingActionButton(
              backgroundColor: GColors.secondary,
              foregroundColor: GColors.white,
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
      endDrawer: const TopDrawer(),
    );
  }
}
