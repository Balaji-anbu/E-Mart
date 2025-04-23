import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/products/product_cards.dart';
import 'package:e_mart/products/product_model.dart';
import 'package:e_mart/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../widgets/cart_model.dart';
import '../pages/cart_page.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui';

class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> with TickerProviderStateMixin {
  late TabController _mainTabController;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  bool _isError = false;
  List<String> _categories = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _visibleCount = 20;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ProductService().fetchProducts();
      final categories = _getUniqueCategories(products);

      setState(() {
        _products = products;
        _filteredProducts = products;
        _categories = categories;
        _mainTabController = TabController(length: categories.length, vsync: this);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  List<String> _getUniqueCategories(List<Product> products) {
    return products.map((p) => p.category).toSet().toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _mainTabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      setState(() {
        _visibleCount += 10;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        return product.title.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query);
      }).toList();
    });
  }

  Widget _buildSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GColors.accent,
      appBar: AppBar(
        backgroundColor: GColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        title: const Text('All Products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border_rounded),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return badges.Badge(
                position: badges.BadgePosition.topEnd(top: -8, end: -4),
                badgeContent: Text('${cart.itemCount}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) => const CartPage(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.shopping_cart_outlined),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? _buildShimmer()
          : _isError
              ? Center(child: Text("❌ Failed to load products.", style: Theme.of(context).textTheme.titleMedium))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(GSizes.md),
                      child: _buildSearchBar(),
                    ),
                    TabBar(
                      controller: _mainTabController,
                      isScrollable: true,
                      labelColor: GColors.primary,
                      unselectedLabelColor: Colors.grey,
                      indicator: BoxDecoration(
                        color: GColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      tabs: _categories.map((category) => Tab(text: category)).toList(),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: TabBarView(
                        controller: _mainTabController,
                        children: _categories.map((category) {
                          final categoryProducts = _searchController.text.isEmpty
                              ? _products.where((p) => p.category == category).toList()
                              : _filteredProducts.where((p) => p.category == category).toList();

                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: SingleChildScrollView(
                              key: ValueKey<String>(category + _searchController.text),
                              controller: _scrollController,
                              child: Padding(
                                padding: const EdgeInsets.all(GSizes.sm),
                                child: ProductCards(
                                  product: categoryProducts.take(_visibleCount).toList(),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
    );
  }
}
