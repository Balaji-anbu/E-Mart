// import 'dart:io';
// import 'package:customizable_counter/customizable_counter.dart';
// import 'package:e_mart/constants/colors.dart';
// import 'package:e_mart/pages/address_list_page.dart';
// import 'package:e_mart/pages/base_stepper.dart';
// import 'package:e_mart/widgets/cart_model.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<Cart>(context, listen: false).fetchCartFromServer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<Cart>(context);
//     print("Building CartPage, items in cart: ${cart.items.length}");

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: GColors.primary,
//         foregroundColor: GColors.white,
//         title: const Text('Cart'),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.favorite_outline,
//               size: 24,
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           BaseStepper(activeStep: 0), // Set the active step to indicate the current page
//           Expanded(
//             child: cart.items.isEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         LottieBuilder.asset(
//                           'asset/json_files/emptyCart.json',
//                           height: 150,
//                           width: 150,
//                           fit: BoxFit.cover,
//                         ),
//                         const SizedBox(height: 20),
//                         const Text(
//                           'Your cart is empty!',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: () {
//                             Navigator.pushReplacementNamed(
//                                 context, "/bottomPage");
//                           },
//                           child: const Text('Start Shopping'),
//                           style: ElevatedButton.styleFrom(
//                             foregroundColor: GColors.textSecondary,
//                             backgroundColor: GColors.secondary,
//                           ),
//                         ),
//                         const SizedBox(height: 150),
//                       ],
//                     ),
//                   )
//                 : Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ListView.builder(
//                       itemCount: cart.items.length,
//                       itemBuilder: (context, index) {
//                         final cartItem = cart.items.values.toList()[index];
//                         final product = cartItem.product; // Accessing the product from CartItem
//                         final variant = product.variants.firstWhere(
//                           (v) => v.sku == cartItem.product,
//                           orElse: () => product.variants.first,
//                         );

//                         return Card(
//                           margin: const EdgeInsets.all(6.0),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 FutureBuilder<List<String>>(
//                                   future: product.downloadImages(),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState == ConnectionState.waiting) {
//                                       return const SizedBox(
//                                         width: 100,
//                                         height: 100,
//                                         child: Center(child: CircularProgressIndicator()),
//                                       );
//                                     }

//                                     final localImages = snapshot.data ?? [];
//                                     final file = localImages.isNotEmpty ? File(localImages.first) : null;

//                                     if (file != null && file.existsSync() && file.lengthSync() > 0) {
//                                       return Container(
//                                         width: 100,
//                                         height: 100,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(4),
//                                           border: Border.all(color: Colors.grey.shade200),
//                                         ),
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(4),
//                                           child: Image.file(
//                                             file,
//                                             fit: BoxFit.cover,
//                                             errorBuilder: (context, error, stackTrace) {
//                                               return const Icon(Icons.image_not_supported);
//                                             },
//                                           ),
//                                         ),
//                                       );
//                                     } else {
//                                       return Container(
//                                         width: 100,
//                                         height: 100,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(4),
//                                           color: Colors.grey[200],
//                                         ),
//                                         child: const Icon(Icons.image_not_supported),
//                                       );
//                                     }
//                                   },
//                                 ),
//                                 const SizedBox(width: 18),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         product.title,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .titleMedium,
//                                       ),
//                                       CustomizableCounter(
//                                         count: cartItem.quantity.toDouble(),
//                                         step: 1,
//                                         minCount: 1,
//                                         maxCount: 100,
//                                         onCountChange: (count) {
//                                           setState(() {
//                                             cart.updateQuantity(
//                                                 product.id,
//                                                 count.toInt());
//                                           });
//                                         },
//                                       ),
//                                       Text(
//                                         '₹${variant.mrp.toStringAsFixed(1)}',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .titleSmall,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Column(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.close),
//                                       onPressed: () {
//                                         setState(() {
//                                           cart.removeItem(product.id);
//                                         });
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//           ),
//           if (cart.items.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Total Price:',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     '₹${cart.totalAmount.toStringAsFixed(1)}',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           if (cart.items.isNotEmpty)
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddressListPage(),
//                   ),
//                 );
//               },
//               child: const Text('Continue'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: GColors.textSecondary,
//                 backgroundColor: GColors.secondary,
//               ),
//             ),
//           const SizedBox(height: 10)
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:customizable_counter/customizable_counter.dart';
import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/pages/address_list_page.dart';
import 'package:e_mart/pages/base_stepper.dart';
import 'package:e_mart/widgets/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final success = await Provider.of<Cart>(context, listen: false).fetchCartFromServer();
      
      // Check if there was an error message from the cart provider
      final errorMsg = Provider.of<Cart>(context, listen: false).errorMessage;
      
      if (!success && errorMsg != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (success && mounted) {
        // Optionally show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cart loaded successfully!'),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle any unexpected errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load cart items: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    
    // Print debug info about the loaded cart
    if (mounted) {
      final cart = Provider.of<Cart>(context, listen: false);
      print('Cart loading complete. Items count: ${cart.items.length}');
      cart.items.forEach((id, item) {
        print('Item: ${item.product.title}, Quantity: ${item.quantity}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    print("Building CartPage, items in cart: ${cart.items.length}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GColors.primary,
        foregroundColor: GColors.white,
        title: const Text('My Cart'),
        actions: [
          IconButton(
            onPressed: () => _loadCartData(), // Refresh cart data
            icon: const Icon(
              Icons.refresh,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_outline,
              size: 24,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your cart...'),
                ],
              ),
            )
          : Column(
              children: [
                BaseStepper(activeStep: 0), 
                Expanded(
                  child: cart.items.isEmpty
                      ? _buildEmptyCart(context)
                      : _buildCartItems(context, cart),
                ),
                if (cart.items.isNotEmpty) _buildCartSummary(context, cart),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            'asset/json_files/emptyCart.json',
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add items to start shopping',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/bottomPage");
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Start Shopping'),
            style: ElevatedButton.styleFrom(
              foregroundColor: GColors.textSecondary,
              backgroundColor: GColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCartItems(BuildContext context, Cart cart) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final cartItem = cart.items.values.toList()[index];
          final product = cartItem.product;
          
          // Get the primary variant (first one)
          final variant = product.variants.isNotEmpty 
              ? product.variants.first
              : null;

          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(product),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        if (variant != null) ...[
                          Row(
                            children: [
                              Text(
                                '₹${variant.mrp.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: GColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (variant.mrp != variant.mrp)
                                Text(
                                  '₹${variant.mrp.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildQuantitySelector(context, cart, product.id, cartItem.quantity),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _showRemoveConfirmation(context, cart, product.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(dynamic product) {
    return FutureBuilder<List<String>>(
      future: product.downloadImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final localImages = snapshot.data ?? [];
        final file = localImages.isNotEmpty ? File(localImages.first) : null;

        if (file != null && file.existsSync() && file.lengthSync() > 0) {
          return Container(
            width: 100,
            height: 100,
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
                  return Container(
                    color: Colors.grey[100],
                    child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
          );
        } else {
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
          );
        }
      },
    );
  }

  Widget _buildQuantitySelector(BuildContext context, Cart cart, String productId, int quantity) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: CustomizableCounter(
        borderRadius: 8,
        count: quantity.toDouble(),
        step: 1,
        minCount: 1,
        maxCount: 100,
        incrementIcon: const Icon(Icons.add, size: 16),
        decrementIcon: const Icon(Icons.remove, size: 16),
        onCountChange: (count) {
          cart.updateQuantity(productId, count.toInt());
        },
      ),
    );
  }

  void _showRemoveConfirmation(BuildContext context, Cart cart, String productId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Item'),
        content: const Text('Are you sure you want to remove this item from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cart.removeItem(productId);
              Navigator.of(ctx).pop();
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, Cart cart) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '₹${cart.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'FREE',
                style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${cart.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: GColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressListPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: GColors.textSecondary,
                backgroundColor: GColors.secondary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('PROCEED TO CHECKOUT'),
            ),
          ),
        ],
      ),
    );
  }
}