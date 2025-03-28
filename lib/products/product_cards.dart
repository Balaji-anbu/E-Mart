import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/products/ProductBottomSheet.dart';
import 'package:e_mart/widgets/cart_model.dart';
import 'package:e_mart/products/product_model.dart';
import 'package:e_mart/widgets/toast_msg.dart';
import 'package:e_mart/widgets/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'all_product_page.dart';

class ProductCards extends StatefulWidget {
  final List<Product> product;

  const ProductCards({required this.product, Key? key}) : super(key: key);

  @override
  _ProductCardsState createState() => _ProductCardsState();
}

class _ProductCardsState extends State<ProductCards> {
  @override
  Widget build(BuildContext context) {
    final products = widget.product;
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
                style: TextStyle(
                  fontSize: GSizes.fontSizeXl1, 
                  fontWeight: FontWeight.w600, 
                  color: GColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                child: Text(
                  'View all',
                  style: TextStyle(
                    fontSize: GSizes.fontSizeMd, 
                    fontWeight: FontWeight.w500, 
                    color: GColors.secondary,
                  ),
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
              childAspectRatio: 0.65,
            ),
            itemCount: products.length > 15 ? 15 : products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final cartItem = cart.items[product.id];
              final wishlistItem = wishlist.items[product.id];

              return Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 227, 229, 234), // Light grey background
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8
                    ),
                  ],
                ),
                child: GestureDetector(
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
                    padding: const EdgeInsets.all(12), // Consistent padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'product-image-${product.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12), // Rounded image
                            child: Image.asset(
                              product.images.isNotEmpty
                                  ? product.images.first
                                  : 'assets/images/placeholder.jpg',
                              height: screenWidth < 600 ? 120 : 160,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12), // Increased spacing
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: GSizes.fontSizeMd, 
                            fontWeight: FontWeight.w600, 
                            color: GColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4), // Space between price and title
                       
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
                            SizedBox(height: 10,),
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
