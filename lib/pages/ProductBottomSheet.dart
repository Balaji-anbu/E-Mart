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

class _ProductModalBottomSheetState extends State<ProductModalBottomSheet> with SingleTickerProviderStateMixin {
  Set<model.ProductOption> selectedOptions = {};
  Map<model.ProductOption, bool> optionsInCart = {};
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    bool hasSelections = selectedOptions.isNotEmpty;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30 * _animation.value),
              topRight: Radius.circular(30 * _animation.value),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Handle indicator at the top
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0, bottom: 16.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 220,
                                child: PageView.builder(
                                  itemCount: widget.product.images.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          widget.product.images[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  widget.product.images.length,
                                  (index) => buildDot(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.title,
                                style: TextStyle(
                                  fontSize: GSizes.fontSizeXl1,
                                  fontWeight: FontWeight.bold,
                                  color: GColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Select Quantities",
                                style: TextStyle(
                                  fontSize: GSizes.fontSizeMd1,
                                  fontWeight: FontWeight.w500,
                                  color: GColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Custom Quantity Selection
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade200, width: 1),
                                ),
                                child: Column(
                                  children: widget.product.options.map((option) {
                                    return buildUnitOption(
                                      option,
                                      cart,
                                      cart.items[widget.product.id],
                                    );
                                  }).toList(),
                                ),
                              ),

                              const SizedBox(height: 15),
                              
                              // Product Details with improved styling
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade200, width: 1),
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    dividerColor: Colors.transparent,
                                  ),
                                  child: ExpansionTile(
                                    tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                    title: Text(
                                      "Product Details",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: GSizes.fontSizeLg,
                                        color: GColors.textPrimary,
                                      ),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                        child: Text(
                                          widget.product.description,
                                          style: TextStyle(
                                            fontSize: GSizes.fontSizeMd,
                                            color: GColors.textPrimary.withOpacity(0.8),
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Bottom action bar with cart total and confirm button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Items: ${cart.itemCount}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "₹${cart.totalAmount.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: GColors.primary,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: hasSelections
                            ? () {
                                // Add all selected options to cart if not already added
                                for (var option in selectedOptions) {
                                  if (!optionsInCart.containsKey(option) || optionsInCart[option] == false) {
                                    final modifiedProduct = model.Product(
                                      id: "${widget.product.id}_${option.quantity}",
                                      title: "${widget.product.title} (${option.quantity})",
                                      description: widget.product.description,
                                      category: widget.product.category,
                                      images: widget.product.images,
                                      options: [option],
                                    );
                                    
                                    cart.addItem(modifiedProduct);
                                    optionsInCart[option] = true;
                                  }
                                }
                                showToast('Products added to cart');
                                Navigator.pop(context);
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                          decoration: BoxDecoration(
                            color: hasSelections ? GColors.secondary : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              color: hasSelections ? GColors.black : Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildUnitOption(model.ProductOption option, Cart cart, CartItem? cartItem) {
    bool isSelected = selectedOptions.contains(option);
    final String optionSpecificId = "${widget.product.id}_${option.quantity}";
    final optionCartItem = cart.items[optionSpecificId];
    final bool isInCart = optionCartItem != null;
    
    if (isInCart && !optionsInCart.containsKey(option)) {
      optionsInCart[option] = true;
    }

    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? GColors.primary.withOpacity(0.3) : Colors.transparent,
          width: 1,
        ),
        color: isSelected ? GColors.primary.withOpacity(0.05) : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedOptions.remove(option);
                if (isInCart) {
                  cart.removeItem(optionSpecificId);
                  optionsInCart[option] = false;
                  showToast('${widget.product.title} (${option.quantity}) removed from cart');
                }
              } else {
                selectedOptions.add(option);
                if (!isInCart) {
                  final modifiedProduct = model.Product(
                    id: optionSpecificId,
                    title: "${widget.product.title} (${option.quantity})",
                    description: widget.product.description,
                    category: widget.product.category,
                    images: widget.product.images,
                    options: [option],
                  );
                  
                  cart.addItem(modifiedProduct);
                  optionsInCart[option] = true;
                  showToast('${widget.product.title} (${option.quantity}) added to cart');
                }
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                // Modern checkbox design
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? GColors.primary : Colors.grey.shade400,
                      width: 1.5,
                    ),
                    color: isSelected ? GColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.quantity.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${option.price.toStringAsFixed(1)}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: GColors.primary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Quantity controls with gesture detector
                if (isSelected && isInCart)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        // Decrease quantity button
                        GestureDetector(
                          onTap: () {
                            if (optionCartItem.quantity > 1) {
                              cart.updateQuantity(
                                  optionSpecificId, optionCartItem.quantity - 1);
                            } else {
                              cart.removeItem(optionSpecificId);
                              optionsInCart[option] = false;
                              // Also uncheck the box when removing the last item
                              selectedOptions.remove(option);
                            }
                            showToast('${widget.product.title} (${option.quantity}) updated');
                            setState(() {});
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: GColors.secondary,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: GSizes.iconSm,
                              ),
                            ),
                          ),
                        ),
                        // Quantity display
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          child: Text(
                            '${optionCartItem.quantity}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Increase quantity button
                        GestureDetector(
                          onTap: () {
                            cart.updateQuantity(
                                optionSpecificId, optionCartItem.quantity + 1);
                            setState(() {});
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: GColors.secondary,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: GSizes.iconSm,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (isSelected && !isInCart)
                  GestureDetector(
                    onTap: () {
                      final modifiedProduct = model.Product(
                        id: optionSpecificId,
                        title: "${widget.product.title} (${option.quantity})",
                        description: widget.product.description,
                        category: widget.product.category,
                        images: widget.product.images,
                        options: [option],
                      );
                      
                      cart.addItem(modifiedProduct);
                      optionsInCart[option] = true;
                      showToast('${widget.product.title} (${option.quantity}) added to cart');
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: GColors.secondary,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index 
            ? GColors.primary 
            : GColors.primary.withOpacity(0.3),
      ),
    );
  }
}
