import 'package:customizable_counter/customizable_counter.dart';
import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/pages/address_list_page.dart';
import 'package:e_mart/pages/base_stepper.dart';

import 'package:e_mart/widgets/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slider_button/slider_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    print("Building CartPage, items in cart: ${cart.items.length}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GColors.primary,
        foregroundColor: GColors.white,
        title: const Text('Cart'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_outline,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Add the BaseStepper below the AppBar
          BaseStepper(
            activeStep: 0, // Set the active step to indicate the current page
          ),
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LottieBuilder.asset(
                          'asset/json_files/emptyCart.json',
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Your cart is empty!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, "/bottomPage");
                          },
                          child: const Text('Start Shopping'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: GColors.textSecondary,
                            backgroundColor: GColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 150),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final cartItem = cart.items.values.toList()[index];
                        final product = cartItem
                            .product; // Accessing the product from CartItem
                        return Card(
                          margin: const EdgeInsets.all(6.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      color: Colors.black,
                                      height: 100,
                                      child: Image.asset(
                                        product.images[0],
                                        // Assuming first image from product's images list
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      CustomizableCounter(
                                        borderColor: Colors.transparent,
                                        borderWidth: 0,
                                        borderRadius: 10,
                                        backgroundColor: Colors.transparent,
                                        buttonText: "",
                                        textColor: Colors.black,
                                        textSize: 12,
                                        count: cartItem.quantity.toDouble(),
                                        // Ensure count is double
                                        step: 1,
                                        minCount: 1,
                                        // Quantity can't be less than 1
                                        maxCount: 100,
                                        incrementIcon: Icon(
                                          Icons.add,
                                          color: GColors.iconPrimary,
                                          size: 15,
                                        ),
                                        decrementIcon: Icon(
                                          Icons.remove,
                                          color: GColors.iconPrimary,
                                          size: 15,
                                        ),
                                        onCountChange: (count) {
                                          setState(() {
                                            cart.updateQuantity(
                                                product.id,
                                                count
                                                    .toInt()); // Convert double to int here
                                          });
                                        },
                                        onIncrement: (count) {
                                          print(
                                              "Incremented to: ${count.toInt()}");
                                        },
                                        onDecrement: (count) {
                                          print(
                                              "Decremented to: ${count.toInt()}");
                                        },
                                      ),
                                      Text(
                                        '₹${product.options[0].price.toStringAsFixed(1)}',
                                        // Assuming first product option's price
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          cart.removeItem(product
                                              .id); // Removes the item and updates the cart
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                          Icons.favorite_outline_rounded),
                                      onPressed: () {
                                        // Add to wishlist logic here (if applicable)
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
                  ),
          ),
          if (cart.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Price:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹${cart.totalAmount.toStringAsFixed(1)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            width: 200.0,
            height: 60.0,
            child: Shimmer.fromColors(
              baseColor: GColors.secondary,
              highlightColor: GColors.primary,
              child: Text(
                'continue >>>',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SliderButton(
            height: 60,
            width: 230,
            highlightedColor: GColors.primary,
            buttonColor: GColors.grey,
            baseColor: GColors.secondary,
            action: () async {
              Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressListPage(),
                          ),
                        );
              return true;
            },
            label: Center(
              child: Text(
                "Slide to continue",
                style: TextStyle(
                    color: GColors.secondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
            icon: Text(
              ">>>",
              style: TextStyle(
                color: GColors.black,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: GColors.secondary,
      //   selectedItemColor: GColors.white,
      //   unselectedItemColor: GColors.white,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.shopping_cart,
      //         color: GColors.textSecondary,
      //       ),
      //       label: 'Continue Shopping',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.payment,
      //         color: GColors.textSecondary,
      //       ),
      //       label: 'Continue',
      //     ),
      //   ],
      //   onTap: (index) {
      //     if (index == 0) {
      //       // Navigate to shopping page logic here
      //     } else if (index == 1) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => AddressListPage(),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
