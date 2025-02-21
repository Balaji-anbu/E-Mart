import 'dart:convert';
import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/widgets/home_app_bar.dart';
import 'package:e_mart/widgets/horizontal_product_cards.dart';
import 'package:e_mart/widgets/image_carousel.dart';
import 'package:e_mart/widgets/popular_categories.dart';
import 'package:e_mart/widgets/product_cards.dart';
import 'package:e_mart/widgets/top_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_mart/widgets/product_model.dart'; // Ensure the import path is correct

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
    _productsFuture = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final String response = await rootBundle.loadString('asset/json_files/samplej.json');
    final data = await json.decode(response);
    return (data['products'] as List)
        .map((productJson) => Product.fromJson(productJson))
        .toList();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  HomeAppBar(),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          }

          final products = snapshot.data!;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Uncomment if location widget is needed
                // const GetLocation(),

                // Search bar
                //const SearchTextBar(),

                // Popular categories
                const PopularCategories(),

                // Image carousel
                 ImageCarousel(),

                // Product card
                ProductCards(product: products,),

                // Horizontal product cards
                 HorizontalProductCards(product: [],),
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
