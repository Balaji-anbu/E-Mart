import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/widgets/product_model.dart';
import 'package:flutter/material.dart'; // Import the Product model

class ProductList extends StatelessWidget {
  final List<Product> products; // Change to List<Product>

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        var product = products[index];
        return Card(
          margin: const EdgeInsets.symmetric(
              horizontal: GSizes.md, vertical: GSizes.sm),
          child: ListTile(
            leading: Image.asset(product.images[0]),
            title: Text(product.title),
            subtitle: Text('Price: ${product.options[0].price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GColors.secondary,
                    foregroundColor: GColors.textSecondary,
                    padding: const EdgeInsets.symmetric(horizontal: GSizes.md),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
