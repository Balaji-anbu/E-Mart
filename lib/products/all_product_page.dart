
import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/products/product_list.dart';
import 'package:e_mart/products/product_model.dart';
import 'package:e_mart/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../widgets/cart_model.dart';
import '../pages/cart_page.dart';

class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> with TickerProviderStateMixin {
  late TabController _mainTabController;
  List<Product> _products = [];
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 4, vsync: this);
    _fetchProducts(); // Fetch products from ProductService
  }

  Future<void> _fetchProducts() async {
    try {
      await ProductService().fetchProducts();
      setState(() {
        _products = ProductService().products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
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
            icon: Icon(Icons.favorite_outline, size: GSizes.iconMd),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return badges.Badge(
                badgeContent: Text(cart.itemCount.toString(), style: TextStyle(color: GColors.textSecondary)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
                  },
                  child: Icon(Icons.shopping_cart_outlined, size: GSizes.iconMd1, color: GColors.textSecondary),
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
          const SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isError
                    ? const Center(child: Text("Failed to load products."))
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

  Widget _buildCategoryTab(String category) {
    final categoryProducts = _getProductsByCategory(category);
    return categoryProducts.isNotEmpty
        ? ProductList(products: categoryProducts)
        : const Center(child: Text("No products available in this category."));
  }

  List<Product> _getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }
}
