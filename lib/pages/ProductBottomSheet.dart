import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/widgets/cart_model.dart';
import 'package:e_mart/widgets/product_model.dart' as model;
import 'package:e_mart/widgets/toast_msg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/sizes.dart';

class ProductModalBottomSheet extends StatefulWidget {
  final model.Product product;

  const ProductModalBottomSheet({super.key, required this.product});

  @override
  _ProductModalBottomSheetState createState() =>
      _ProductModalBottomSheetState();
}

class _ProductModalBottomSheetState extends State<ProductModalBottomSheet> {
  model.ProductOption? selectedOption;

  @override
  void initState() {
    super.initState();
    // Default selection for the first available option
    selectedOption = widget.product.options.isNotEmpty
        ? widget.product.options.first
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItem = cart.items[widget.product.id];

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: Stack(
        children:[ Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            itemCount: widget.product.images.length,
                            itemBuilder: (context, index) {
                              return Image.asset(widget.product.images[index]);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                widget.product.images.length, buildDot),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.title,
                            style: TextStyle(
                                fontSize: GSizes.fontSizeXl1,
                                fontWeight: FontWeight.bold,
                                color: GColors.textPrimary)),
                        const SizedBox(height: 10),
                        Text("Select Quantity",
                            style: TextStyle(
                                fontSize: GSizes.fontSizeMd1,
                                fontWeight: FontWeight.w400,
                                color: GColors.textPrimary)),
                        const SizedBox(height: 15),
                        // Custom Quantity Selection
                        Container(
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: GColors.borderGrey, width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: widget.product.options.map((option) {
                              return buildUnitOption(
                                option,
                                cart,
                                cartItem,
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Product Details with Border
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: GColors.borderPrimary, width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              "Product Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: GSizes.fontSizeXl),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.product.description,
                                  style: TextStyle(
                                      fontSize: GSizes.fontSizeSm1,
                                      color: GColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  // Cart Total and Confirm Button
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      color: GColors.secondary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Items: ${cart.itemCount}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: GColors.white)),
                              Text(
                                  "Total: ₹${cart.totalAmount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: GColors.white)),
                            ],
                          ),
                          if (selectedOption != null)
                            TextButton(
                              onPressed: () {
                                // if (cartItem == null) {
                                //   final selectedOption = widget.product.options
                                //       .firstWhere((option) =>
                                //   option.quantity == selectedOption);
                                //   cart.addItem(widget.product);
                                // }
                                Navigator.pop(context);
                              },
                              child: const Text("Confirm",
                                  style: TextStyle(
                                      color: GColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget buildUnitOption(
      model.ProductOption option, Cart cart, CartItem? cartItem) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedOption == option
                ? GColors.primary
                : GColors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(
              selectedOption == option
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: selectedOption == option
                  ? GColors.primary
                  : GColors.grey,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(option.quantity.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("₹${option.price.toStringAsFixed(1)}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            // Show "Add" button or quantity management row
            if (selectedOption == option)
              cartItem == null
                  ? ElevatedButton(
                onPressed: () {
                  //cart.addItem(
                    // widget.product,
                    // selectedOption!.quantity,
                    // selectedOption!.price,);
                  showToast('${widget.product.title} added to cart');
                  setState(() {}); // Refresh the UI to show quantity buttons
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: GColors.secondary,
                    foregroundColor: GColors.white),
                child: const Icon(Icons.add),
              )
                  : Row(
                children: [
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
                        cart.updateQuantity(
                            widget.product.id,
                            cartItem.quantity - 1);
                      } else {
                        cart.removeItem(widget.product.id);
                      }
                      showToast(
                          '${widget.product.title} removed from cart');
                      setState(() {}); // Refresh the UI
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('${cartItem.quantity}'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(5),
                      minimumSize: const Size(30, 30),
                      backgroundColor: GColors.secondary,
                      foregroundColor: GColors.white,
                    ),
                    child: Icon(Icons.add, size: GSizes.iconSm),
                    onPressed: () {
                      cart.updateQuantity(
                          widget.product.id,
                          cartItem.quantity + 1);
                      setState(() {}); // Refresh the UI
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: GColors.primary.withOpacity(0.5),
      ),
    );
  }
}
