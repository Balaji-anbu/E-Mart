import 'dart:io';
import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/pages/cart_page.dart';
import 'package:e_mart/widgets/cart_model.dart';
import 'package:e_mart/widgets/toast_msg.dart';
import 'package:e_mart/widgets/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<Wishlist>(context); // Wishlist provider
    final cart = Provider.of<Cart>(context); // Cart provider

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GColors.primary,
        title: Text(
          'Wishlist',
          style: TextStyle(color: GColors.textSecondary),
        ),
        actions: [
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
      body: Consumer<Wishlist>(
        builder: (context, wishlist, child) {
          if (wishlist.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    'asset/json_files/emptyCart.json',
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your wishlist is empty!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/bottomPage");
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: GColors.textSecondary,
                        backgroundColor: GColors.secondary),
                    child: const Text('Continue Shopping'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: wishlist.items.length,
            itemBuilder: (ctx, i) {
              final productId = wishlist.items.keys.toList()[i];
              final wishlistItem = wishlist.items[productId]!;
              final product = wishlistItem.product;
              final firstVariant =
                  product.variants.isNotEmpty ? product.variants.first : null;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: FutureBuilder<List<String>>(
                    future: product.downloadImages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          width: 60,
                          height: 60,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final localImages = snapshot.data ?? [];
                      final file = localImages.isNotEmpty ? File(localImages.first) : null;

                      if (file != null && file.existsSync() && file.lengthSync() > 0) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              file,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported);
                              },
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: const Icon(Icons.image_not_supported),
                        );
                      }
                    },
                  ),
                  title: Text(product.title),
                  subtitle: firstVariant != null
                      ? Text(
                          firstVariant.specialPrice != null
                              ? '₹${firstVariant.specialPrice}'
                              : '₹${firstVariant.mrp}',
                          style: const TextStyle(
                            color: GColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text('No price available'),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: GSizes.iconSm,
                          color: GColors.iconPrimary,
                        ),
                        onPressed: () {
                          wishlist.removeItem(product.id);
                          showToast('${product.title} removed from wishlist');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: GColors.iconPrimary,
                          size: GSizes.iconMd1,
                        ),
                        onPressed: () {
                          cart.addItem(
                            product, // Pass the entire product object
                          );
                          showToast('${product.title} added to cart'); // Add the product to the cart
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
