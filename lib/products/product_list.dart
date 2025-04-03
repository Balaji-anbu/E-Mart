import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/products/product_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ProductList extends StatelessWidget {
  final List<Product> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        var product = products[index];
        var firstVariant = product.variants.isNotEmpty ? product.variants.first : null;

        return Card(
          margin: const EdgeInsets.symmetric(
              horizontal: GSizes.md, vertical: GSizes.sm),
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
                return localImages.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(
                          File(localImages.first),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.image_not_supported),
                      );
              },
            ),
            title: Text(product.title),
            subtitle: firstVariant != null
                ? Text('MRP: ₹${firstVariant.mrp}')
                : const Text('No variant available'),
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
