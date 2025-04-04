import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/products/ProductBottomSheet.dart';
import 'package:e_mart/products/all_product_page.dart';
import 'package:e_mart/widgets/cart_model.dart';
import 'package:e_mart/products/product_model.dart';
import 'package:e_mart/widgets/toast_msg.dart';
import 'package:e_mart/widgets/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_mart/services/product_service.dart';
import 'dart:io';

class HorizontalProductCards extends StatefulWidget {
  final List<Product> product;

  const HorizontalProductCards({required this.product, Key? key}) : super(key: key);

  @override
  State<HorizontalProductCards> createState() => _HorizontalProductCardsState();
}

class _HorizontalProductCardsState extends State<HorizontalProductCards> {
  @override
  Widget build(BuildContext context) {
    final products = widget.product.isNotEmpty ? widget.product : ProductService().products;
    final cart = Provider.of<Cart>(context);
    final wishlist = Provider.of<Wishlist>(context);

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
                child: Row(
                  children: [
                    Text(
                      'View all',
                      style: TextStyle(
                          fontSize: GSizes.fontSizeMd,
                          fontWeight: FontWeight.w500,
                          color: GColors.secondary),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: GColors.secondary),
                  ],
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
          const SizedBox(height: 4),
          SizedBox(
            height: 320, // Fixed height for consistent presentation
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                final cartItem = cart.items[product.id];
                final wishlistItem = wishlist.items[product.id];

                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: GColors.accent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image with wishlist button overlay and discount badge
                      Stack(
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
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                ),
                                child: FutureBuilder<List<String>>(
                                  future: product.downloadImages(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(strokeWidth: 2.5),
                                        ),
                                      );
                                    }
                                    
                                    final localImages = snapshot.data ?? [];
                                    return localImages.isNotEmpty
                                        ? Image.file(
                                            File(localImages.first),
                                            fit: BoxFit.cover,
                                          )
                                        : const Center(
                                            child: Icon(Icons.image_not_supported, color: Colors.grey),
                                          );
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Sale discount tag - top left corner
                          if (product.variants.isNotEmpty && 
                              product.variants.first.specialPrice != null)
                            Builder(
                              builder: (context) {
                                final mrp = product.variants.first.mrp;
                                final specialPrice = product.variants.first.specialPrice!;
                                final discountPercentage = ((mrp - specialPrice) / mrp) * 100;
                                
                                // Only show badge if discount is more than 1%
                                if (discountPercentage > 1) {
                                  return Positioned(
                                    top: 0,
                                    left: 0,
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
                                        '${discountPercentage.toStringAsFixed(0)}% OFF',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: GSizes.fontSizeSm,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          // Wishlist button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                constraints: const BoxConstraints(
                                  minHeight: 36,
                                  minWidth: 36,
                                ),
                                padding: EdgeInsets.zero,
                                iconSize: 20,
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
                                  wishlistItem == null
                                      ? Icons.favorite_outline_rounded
                                      : Icons.favorite,
                                  color: GColors.error,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Product details
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product title - limited to 2 lines with overflow ellipsis
                            SizedBox(
                              height: 40, // Fixed height for two lines
                              child: Text(
                                product.title,
                                style: TextStyle(
                                  fontSize: GSizes.fontSizeMd,
                                  fontWeight: FontWeight.w500,
                                  color: GColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Pricing section
                            if (product.variants.isNotEmpty) ...[
                              Row(
                                children: [
                                  Text(
                                    product.variants.first.specialPrice != null
                                        ? '₹${product.variants.first.specialPrice}'
                                        : '₹${product.variants.first.mrp}',
                                    style: TextStyle(
                                      fontSize: GSizes.fontSizeMd1,
                                      fontWeight: FontWeight.w600,
                                      color: GColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  if (product.variants.first.specialPrice != null)
                                    Text(
                                      '₹${product.variants.first.mrp}',
                                      style: TextStyle(
                                        fontSize: GSizes.fontSizeSm,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                ],
                              ),

                            ],
                            const SizedBox(height: 8),
                            // Cart interaction section
                            cartItem == null
                                ? SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        backgroundColor: GColors.secondary,
                                        foregroundColor: GColors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        cart.addItem(product);
                                        showToast('${product.title} added to cart');
                                      },
                                      child: Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          fontSize: GSizes.fontSizeSm,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: GColors.secondary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Decrease button
                                        InkWell(
                                          onTap: () {
                                            if (cartItem.quantity > 1) {
                                              cart.updateQuantity(product.id, cartItem.quantity - 1);
                                            } else {
                                              cart.removeItem(product.id);
                                              showToast('${product.title} removed from cart');
                                            }
                                          },
                                          child: Container(
                                            height: double.infinity,
                                            width: 34,
                                            decoration: BoxDecoration(
                                              color: GColors.secondary,
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomLeft: Radius.circular(8),
                                              ),
                                            ),
                                            child: Icon(Icons.remove, color: GColors.white, size: 18),
                                          ),
                                        ),
                                        // Quantity
                                        Text(
                                          '${cartItem.quantity}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: GColors.secondary,
                                          ),
                                        ),
                                        // Increase button
                                        InkWell(
                                          onTap: () {
                                            cart.updateQuantity(product.id, cartItem.quantity + 1);
                                          },
                                          child: Container(
                                            height: double.infinity,
                                            width: 34,
                                            decoration: BoxDecoration(
                                              color: GColors.secondary,
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ),
                                            ),
                                            child: Icon(Icons.add, color: GColors.white, size: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}