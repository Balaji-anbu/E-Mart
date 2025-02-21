import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/pages/ProductBottomSheet.dart';
import 'package:e_mart/widgets/cart_model.dart';
import 'package:e_mart/widgets/product_model.dart' as model;
import 'package:e_mart/widgets/product_model.dart';
import 'package:e_mart/widgets/toast_msg.dart';
import 'package:e_mart/widgets/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../pages/all_product_page.dart';

class ProductCards extends StatefulWidget {
  final List<Product> product;

  const ProductCards({required this.product, Key? key}) : super(key: key);

  @override
  _ProductCardsState createState() => _ProductCardsState();
}

class _ProductCardsState extends State<ProductCards> {
  List<model.Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final String response = await rootBundle.loadString('asset/json_files/samplej.json');
      final data = json.decode(response);
      setState(() {
        products = (data['products'] as List)
            .map((i) => model.Product.fromJson(i))
            .toList();
      });
    } catch (error) {
      print('Error loading products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final wishlist = Provider.of<Wishlist>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    
    return Padding(
      padding: const EdgeInsets.all(GSizes.sm),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Products',
                style: TextStyle(fontSize: GSizes.fontSizeXl1, fontWeight: FontWeight.w600, color: GColors.textPrimary),
              ),
              const Spacer(),
              GestureDetector(
                child: Text(
                  'View all',
                  style: TextStyle(
                      fontSize: GSizes.fontSizeMd,
                      fontWeight: FontWeight.w500,
                      color: GColors.secondary),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllProductPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth < 600 ? 2 : 3,
              crossAxisSpacing: GSizes.sm,
              mainAxisSpacing: GSizes.sm,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final cartItem = cart.items[product.id];
              final wishlistItem = wishlist.items[product.id];

              return Card(
                color: GColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return ProductModalBottomSheet(product: product);
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            product.images.isNotEmpty ? product.images.first : 'assets/images/placeholder.jpg',
                            height: screenWidth < 600 ? 100 : 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.title,
                        style: TextStyle(fontSize: GSizes.fontSizeMd, fontWeight: FontWeight.w600, color: GColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '₹${product.options.isNotEmpty ? product.options.first.price.toStringAsFixed(2) : '0.00'}',
                        style: TextStyle(fontSize: GSizes.fontSizeMd, fontWeight: FontWeight.w600, color: Colors.green),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (wishlistItem == null) {
                                wishlist.addItem(product);
                                showToast('${product.title} added to wishlist');
                              } else {
                                wishlist.removeItem(product.id);
                                showToast('${product.title} removed from wishlist');
                              }
                            },
                            icon: Icon(
                              wishlistItem == null ? Icons.favorite_outline : Icons.favorite,
                              color: GColors.error,
                            ),
                          ),
                          cartItem == null
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(8),
                                    backgroundColor: GColors.secondary,
                                  ),
                                  child: const Icon(Icons.add, color: Colors.white),
                                  onPressed: () {
                                    cart.addItem(product);
                                    showToast('${product.title} added to cart');
                                  },
                                )
                              : Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (cartItem.quantity > 1) {
                                          cart.updateQuantity(product.id, cartItem.quantity - 1);
                                        } else {
                                          cart.removeItem(product.id);
                                          showToast('${product.title} removed from cart');
                                        }
                                      },
                                      icon: Icon(Icons.remove, color: Colors.red),
                                    ),
                                    Text('${cartItem.quantity}', style: TextStyle(color: Colors.black, fontSize: GSizes.fontSizeMd)),
                                    IconButton(
                                      onPressed: () {
                                        cart.updateQuantity(product.id, cartItem.quantity + 1);
                                      },
                                      icon: Icon(Icons.add, color: Colors.greenAccent),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}
