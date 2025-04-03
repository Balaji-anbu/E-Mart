import 'dart:io';
import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/products/ProductBottomSheet.dart';
import 'package:e_mart/widgets/cart_model.dart';
import 'package:e_mart/products/product_model.dart';
import 'package:e_mart/widgets/toast_msg.dart';
import 'package:e_mart/widgets/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:e_mart/components/product_badge.dart';

class ProductCards extends StatefulWidget {
  final List<Product> product;

  const ProductCards({required this.product, Key? key}) : super(key: key);

  @override
  _ProductCardsState createState() => _ProductCardsState();
}

class _ProductCardsState extends State<ProductCards> {
  Map<String, List<Product>> categorizeProducts(List<Product> products) {
    Map<String, List<Product>> categorized = {};
    for (var product in products) {
      categorized.putIfAbsent(product.category, () => []).add(product);
    }
    return categorized;
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.product;
    final cart = Provider.of<Cart>(context);
    final wishlist = Provider.of<Wishlist>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final categorizedProducts = categorizeProducts(products);

    return Padding(
      padding: const EdgeInsets.all(GSizes.sm),
      child: Column(
        children: categorizedProducts.entries.map((entry) {
          int visibleCount = 11; // Show initial 10 products per category

          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: GSizes.fontSizeXl1,
                      fontWeight: FontWeight.w600,
                      color: GColors.textPrimary,
                    ),
                  ),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth < 600 ? 2 : 3,
                      crossAxisSpacing: GSizes.sm,
                      mainAxisSpacing: GSizes.sm,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: (visibleCount < entry.value.length) ? visibleCount : entry.value.length,
                    itemBuilder: (context, index) {
                      final product = entry.value[index];
                      final firstVariant = product.variants.isNotEmpty ? product.variants.first : null;
                      final cartItem = cart.items[product.id];
                      final wishlistItem = wishlist.items[product.id];

                      if (firstVariant == null) {
                        return const SizedBox(); // Skip products without variants
                      }

                      return FutureBuilder<List<String>>(
                        future: product.downloadImages(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return  Center(child: Lottie.asset('asset/json_files/product_load.json'));
                          } else if (snapshot.hasError) {
                            return const Center(child: Icon(Icons.error));
                          }

                          final localImages = snapshot.data ?? [];
                          final hasImage = localImages.isNotEmpty;

                          return Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 227, 229, 234),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                
                                BoxShadow(
                                  
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return ProductModalBottomSheet(product: product);
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: 'product-image-${product.id}',
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: hasImage
                                                ? Image.file(
                                                    File(localImages.first),
                                                    height: screenWidth < 600 ? 115 : 160,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    height: screenWidth < 600 ? 115 : 160,
                                                    width: double.infinity,
                                                    color: Colors.grey[300],
                                                    child: const Icon(Icons.image_not_supported),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          product.title,
                                          style: TextStyle(
                                            fontSize: GSizes.fontSizeMd,
                                            fontWeight: FontWeight.w600,
                                            color: GColors.textPrimary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        // Display price information from variant
                                        if (firstVariant.specialPrice != null) ...[
                                          Text(
                                            '₹${firstVariant.specialPrice}',
                                            style: TextStyle(
                                              fontSize: GSizes.fontSizeMd,
                                              fontWeight: FontWeight.w600,
                                              color: GColors.primary,
                                            ),
                                          ),
                                          Text(
                                            '₹${firstVariant.mrp}',
                                            style: TextStyle(
                                              fontSize: GSizes.fontSizeSm,
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ] else
                                          Text(
                                            '₹${firstVariant.mrp}',
                                            style: TextStyle(
                                              fontSize: GSizes.fontSizeMd,
                                              fontWeight: FontWeight.w600,
                                              color: GColors.primary,
                                            ),
                                          ),
                                        // Show out of stock if applicable
                                        if (!firstVariant.inStock)
                                          const Text(
                                            'Out of Stock',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        const Spacer(),
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
                                            SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: () {
                                                if (cartItem == null) {
                                                  cart.addItem(product);
                                                  showToast('${product.title} added to cart');
                                                } else {
                                                  cart.removeItem(product.id);
                                                  showToast('${product.title} removed from cart');
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: GColors.secondary,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                padding: const EdgeInsets.all(10),
                                                child: cartItem == null
                                                    ? Icon(Icons.add, color: Colors.white)
                                                    : Row(
                                                        children: [
                                                          Icon(Icons.remove, color: Colors.red),
                                                          Text('${cartItem.quantity}', style: TextStyle(color: Colors.black, fontSize: GSizes.fontSizeMd)),
                                                          Icon(Icons.add, color: Colors.greenAccent),
                                                        ],
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (product.badgeType != BadgeType.none)
                                  ProductBadge(type: product.badgeType),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  ),
                  if (visibleCount < entry.value.length)
                    TextButton(
                      onPressed: () => setState(() => visibleCount += 10),
                      child: Text("Load More"),
                    ),
                ],
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
