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
  @override
  void initState() {
    super.initState();
    Provider.of<Cart>(context, listen: false).fetchCartFromServer();
  }


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
          BaseStepper(activeStep: 0), // Set the active step to indicate the current page
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
                        final product = cartItem.product; // Accessing the product from CartItem
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
                                    children: [
                                      Text(
                                        product.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      CustomizableCounter(
                                        count: cartItem.quantity.toDouble(),
                                        step: 1,
                                        minCount: 1,
                                        maxCount: 100,
                                        onCountChange: (count) {
                                          setState(() {
                                            cart.updateQuantity(
                                                product.id,
                                                count.toInt());
                                          });
                                        },
                                      ),
                                      Text(
                                        '₹${product.options[0].price.toStringAsFixed(1)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          cart.removeItem(product.id);
                                        });
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
          if (cart.items.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressListPage(),
                  ),
                );
              },
              child: const Text('Continue'),
              style: ElevatedButton.styleFrom(
                foregroundColor: GColors.textSecondary,
                backgroundColor: GColors.secondary,
              ),
            ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
