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
      body: wishlist.items.isEmpty
          ? Center(
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
              style: ElevatedButton.styleFrom(foregroundColor: GColors.textSecondary,backgroundColor: GColors.secondary),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: wishlist.items.length,
        itemBuilder: (context, index) {
          final productId = wishlist.items.keys.toList()[index];
          final wishlistItem = wishlist.items[productId]!;
          final product = wishlistItem.product;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    child: Image.asset(
                      product.images.first, // Displaying the first image from the product
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: GSizes.fontSizeMd1,
                            fontWeight: FontWeight.w500,
                            color: GColors.textPrimary,
                          ),
                        ),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: GSizes.fontSizeSm1,
                            color: GColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '₹${product.options.first.price.toStringAsFixed(2)}', // Price from the first ProductOption
                          style: TextStyle(
                            fontSize: GSizes.fontSizeSm1,
                            fontWeight: FontWeight.w500,
                            color: GColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
