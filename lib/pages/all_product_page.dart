import 'dart:convert';
import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/widgets/product_list.dart';
import 'package:e_mart/widgets/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../widgets/cart_model.dart';
import 'cart_page.dart';

class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> with TickerProviderStateMixin {
  late TabController _mainTabController;

  List<Product> _products = []; // Use List<Product>
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 4, vsync: this);
    _loadProducts();  // Load product data on init
  }

  Future<void> _loadProducts() async {
    try {
      final String response = await rootBundle.loadString('asset/json_files/samplej.json');
      final data = json.decode(response);
      setState(() {
        // Parse the product data into Product model objects
        _products = (data['products'] as List)
            .map((productJson) => Product.fromJson(productJson))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading products: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GColors.primary,
        foregroundColor: GColors.textSecondary,
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite_outline,
              size: GSizes.iconMd,
            ),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return badges.Badge(
                badgeContent: Text(
                  cart.itemCount.toString(),
                  style: TextStyle(color: GColors.textSecondary),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: GSizes.iconMd1,
                    color: GColors.textSecondary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(GSizes.sm),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search our products',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          TabBar(
            labelColor: GColors.primary,
            indicatorColor: GColors.primary,
            controller: _mainTabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Magic Millets'),
              Tab(text: 'Traditional Rice'),
              Tab(text: 'Avul - Flakes'),
              Tab(text: 'Honey/Dry Fruits'),
            ],
          ),
          SizedBox(height: 10,),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
              controller: _mainTabController,
              children: [
                _buildCategoryTab('Magic Millets'),
                _buildCategoryTab('Traditional Rice'),
                _buildCategoryTab('Avul - Flakes'),
                _buildCategoryTab('Honey/Dry Fruits'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build the category tab with dynamic data
  Widget _buildCategoryTab(String category) {
    final categoryProducts = _getProductsByCategory(category);
    return ProductList(products: categoryProducts);
  }

  // Filter products by category
  List<Product> _getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }
}
