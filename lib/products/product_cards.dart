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

  Widget buildProductCard(BuildContext context, Product product, double screenWidth) {
    final firstVariant = product.variants.isNotEmpty ? product.variants.first : null;

    if (firstVariant == null) {
      return const SizedBox();
    }

    // Calculate discount percentage if special price exists
    int discountPercentage = 0;
    if (firstVariant.specialPrice != null) {
      final mrp = firstVariant.mrp;
      final specialPrice = firstVariant.specialPrice!;
      discountPercentage = ((mrp - specialPrice) / mrp * 100).round();
    }

    return FutureBuilder<List<String>>(
      future: product.downloadImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Lottie.asset('asset/json_files/product_load.json'));
        } else if (snapshot.hasError) {
          return const Center(child: Icon(Icons.error));
        }

        final localImages = snapshot.data ?? [];
        final hasImage = localImages.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Product content
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image container with rounded corners
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Hero(
                        tag: 'product-image-${product.id}',
                        child: Container(
                          height: screenWidth < 600 ? 190 : 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                          ),
                          child: hasImage
                              ? Image.file(
                                  File(localImages.first),
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: Colors.grey[400],
                                ),
                        ),
                      ),
                    ),
                    
                    // Product details
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product title
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF303030),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          
                          // Price section
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (firstVariant.specialPrice != null) ...[
                                Text(
                                  '₹${firstVariant.specialPrice}',
                                  style: TextStyle(
                                    fontSize: GSizes.fontSizeMd + 1,
                                    fontWeight: FontWeight.w700,
                                    color: GColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '₹${firstVariant.mrp}',
                                  style: TextStyle(
                                    fontSize: GSizes.fontSizeSm,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              
                              ] else
                                Text(
                                  '₹${firstVariant.mrp}',
                                  style: TextStyle(
                                    fontSize: GSizes.fontSizeMd + 1,
                                    fontWeight: FontWeight.w700,
                                    color: GColors.primary,
                                  ),
                                ),
                            ],
                          ),
                          
                          if (!firstVariant.inStock)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Out of Stock',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          
                          const SizedBox(height: 12),
                          
                          // Action buttons 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Wishlist button
                              Consumer<Wishlist>(
                                builder: (ctx, wishlist, _) {
                                  final isInWishlist = wishlist.items.containsKey(product.id);
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: isInWishlist ? Colors.red[50] : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(8),
                                      onPressed: () {
                                        if (isInWishlist) {
                                          wishlist.removeItem(product.id);
                                          showToast('${product.title} removed from wishlist');
                                        } else {
                                          wishlist.addItem(product);
                                          showToast('${product.title} added to wishlist');
                                        }
                                      },
                                      icon: Icon(
                                        isInWishlist ? Icons.favorite : Icons.favorite_outline,
                                        color: isInWishlist ? Colors.red : Colors.grey[600],
                                        size: 20,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              // Cart button
                              Consumer<Cart>(
                                builder: (ctx, cart, _) {
                                  final cartItem = cart.items[product.id];
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: GestureDetector(
                                        onTap: !firstVariant.inStock ? null : () {
                                          if (cartItem == null) {
                                            cart.addItem(product);
                                            showToast('${product.title} added to cart');
                                          }
                                        },
                                        child: Container(
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: !firstVariant.inStock 
                                                ? Colors.grey[300] 
                                                : (cartItem == null ? GColors.secondary : Colors.green[50]),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: cartItem == null
                                              ? Center(
                                                  child: Text(
                                                    !firstVariant.inStock ? 'Unavailable' : 'Add to Cart',
                                                    style: TextStyle(
                                                      color: !firstVariant.inStock ? Colors.grey[600] : Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                )
                                              : Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                      constraints: const BoxConstraints(),
                                                      padding: EdgeInsets.zero,
                                                      icon: Container(
                                                        padding: const EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                          color: Colors.red[50],
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 16,
                                                          color: Colors.red[700],
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        if (cartItem.quantity > 1) {
                                                          cart.removeItem(product.id);
                                                        } else {
                                                          cart.removeItem(product.id);
                                                          showToast('${product.title} removed from cart');
                                                        }
                                                      },
                                                    ),
                                                    Text(
                                                      '${cartItem.quantity}',
                                                      style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      constraints: const BoxConstraints(),
                                                      padding: EdgeInsets.zero,
                                                      icon: Container(
                                                        padding: const EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                          color: Colors.green[50],
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 16,
                                                          color: Colors.green[700],
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        cart.addItem(product.id as Product);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Badge 
              if (product.badgeType != BadgeType.none)
                Positioned(
                  top: 150,
                  left: 10,
                  child: ProductBadge(type: product.badgeType),
                ),
              
              // Discount badge (only if discount percentage > 1%)
              if (discountPercentage > 1)
                Positioned(
                  top: 1,
                  left: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                    ),
                    child: Text(
                      '$discountPercentage% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final categorizedProducts = categorizeProducts(widget.product);

    return Padding(
      padding: const EdgeInsets.all(GSizes.sm),
      child: Column(
        children: categorizedProducts.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF303030),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // View all products in this category
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: GColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth < 600 ? 2 : 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.52,
                ),
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  final product = entry.value[index];
                  return buildProductCard(context, product, screenWidth);
                },
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}