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
      body: _isLoading
          ? Center(child: Lottie.asset('asset/json_files/product_load.json'))
          : _isError
              ? const Center(child: Text("Failed to load products."))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(GSizes.sm),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search products...',
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    TabBar(
                      labelColor: GColors.primary,
                      indicatorColor: GColors.primary,
                      controller: _mainTabController,
                      isScrollable: true,
                      tabs: _categories.map((category) => Tab(text: category)).toList(),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: TabBarView(
                        controller: _mainTabController,
                        children: _categories.map((category) {
                          final categoryProducts = _searchController.text.isEmpty
                              ? _products.where((p) => p.category == category).toList()
                              : _filteredProducts.where((p) => p.category == category).toList();

                          return SingleChildScrollView(
                            controller: _scrollController,
                            child: ProductCards(
                              product: categoryProducts.take(_visibleCount).toList(),
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
