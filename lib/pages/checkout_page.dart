import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/pages/payment_service.dart';
import 'package:e_mart/widgets/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'base_stepper.dart';
import 'dart:io';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late PaymentService _paymentService;

  @override
  void initState() {
    super.initState();
    _paymentService = PaymentService(context);
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: GColors.primary,
        foregroundColor: GColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseStepper(activeStep: 2), // Add the stepper here
            const SizedBox(height: 10),
            Text(
              'Items in your cart',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final cartItem = cart.items.values.toList()[index];
                  final product = cartItem.product;
                  final variant = product.variants.firstWhere(
                    (v) => v.sku == cartItem.product,
                    orElse: () => product.variants.first,
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: FutureBuilder<List<String>>(
                        future: product.downloadImages(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final localImages = snapshot.data ?? [];
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: localImages.isNotEmpty
                                  ? Image.file(
                                      File(localImages.first),
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      ),
                      title: Text(product.title),
                      subtitle: Text('Quantity: ${cartItem.quantity}'),
                      trailing: Text(
                        '₹${(variant.mrp * cartItem.quantity).toStringAsFixed(2)}',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '₹${cart.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Proceed with payment
                _paymentService.openCheckout(cart.totalAmount);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: GColors.secondary,
                foregroundColor: GColors.textSecondary,
              ),
              child: const Center(
                child: Text('Proceed to Pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
