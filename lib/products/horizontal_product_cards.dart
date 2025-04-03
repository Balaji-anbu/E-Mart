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
                style: TextStyle(fontSize: GSizes.fontSizeXl1, fontWeight: FontWeight.w500, color: GColors.textPrimary),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: products.map((product) {
                  final cartItem = cart.items[product.id];
                  final wishlistItem = wishlist.items[product.id];

                  return Card(
                    color: GColors.accent,
                    margin: const EdgeInsets.symmetric(vertical: GSizes.sm, horizontal: GSizes.sm),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
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
                            child: FutureBuilder<List<String>>(
                              future: product.downloadImages(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox(
                                    height: 130,
                                    width: 160,
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }
                                
                                final localImages = snapshot.data ?? [];
                                return localImages.isNotEmpty
                                    ? Image.file(
                                        File(localImages.first),
                                        height: 130,
                                        width: 160,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 130,
                                        width: 160,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.image_not_supported),
                                      );
                              },
                            ),
                          ),
                          Text(
                            product.title,
                            style: TextStyle(
                                fontSize: GSizes.fontSizeMd1,
                                fontWeight: FontWeight.w500,
                                color: GColors.textPrimary),
                          ),
                          if (product.variants.isNotEmpty) ...[
                            Text(
                              product.variants.first.specialPrice != null
                                  ? '₹${product.variants.first.specialPrice}'
                                  : '₹${product.variants.first.mrp}',
                              style: TextStyle(
                                fontSize: GSizes.fontSizeMd,
                                fontWeight: FontWeight.w600,
                                color: GColors.primary,
                              ),
                            ),
                            if (product.variants.first.specialPrice != null)
                              Text(
                                '₹${product.variants.first.mrp}',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Wishlist IconButton
                              IconButton(
                                onPressed: () {
                                  // If wishlistItem is null, add product to wishlist; otherwise, remove it.
                                  if (wishlistItem == null) {
                                    wishlist.addItem(
                                      product, // Pass the entire product object
                                    );
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

                              // Add to Cart Button (only show if the product is not in the cart)
                              cartItem == null
                                  ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(4),
                                  minimumSize: const Size(25, 25),
                                  backgroundColor: GColors.secondary,
                                  foregroundColor: GColors.white,
                                ),
                                child: const Icon(Icons.add),
                                onPressed: () {
                                  cart.addItem(
                                    product, // Pass the entire product object
                                  );
                                  showToast('${product.title} added to cart');
                                },
                              )
                                  : const SizedBox.shrink(),

                              // Quantity Update Row (only show if the product is in the cart)
                              cartItem != null
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Decrease Quantity or Remove from Cart
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(5),
                                      minimumSize: const Size(25, 25),
                                      backgroundColor: GColors.secondary,
                                      foregroundColor: GColors.white,
                                    ),
                                    child: Icon(Icons.remove, size: GSizes.iconSm),
                                    onPressed: () {
                                      if (cartItem.quantity > 1) {
                                        cart.updateQuantity(product.id, cartItem.quantity - 1);
                                      } else {
                                        cart.removeItem(product.id);
                                        showToast('${product.title} removed from cart');
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('${cartItem.quantity}'),
                                  ),
                                  // Increase Quantity
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(5),
                                      minimumSize: const Size(30, 30),
                                      backgroundColor: GColors.secondary,
                                      foregroundColor: GColors.white,
                                    ),
                                    child: Icon(Icons.add, size: GSizes.iconSm),
                                    onPressed: () {
                                      cart.updateQuantity(product.id, cartItem.quantity + 1);
                                    },
                                  ),
                                ],
                              )
                                  : const SizedBox.shrink(),
                            ],
                          )

                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
