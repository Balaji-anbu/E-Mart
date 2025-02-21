import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/pages/cart_page.dart';
import 'package:e_mart/widgets/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class categoriesPage extends StatelessWidget {
  categoriesPage({super.key});

  final List<ProductCategory> categories = [
    ProductCategory(
      title: 'Beverages',
      imagePath: 'asset/images/foodgrain.jpg',
      dropdownContent: ['Dropdown Content 1', 'Dropdown Content 2'],
    ),
    ProductCategory(
      title: 'Snacks',
      imagePath: 'asset/images/foodgrain.jpg',
      dropdownContent: ['Dropdown Content 3', 'Dropdown Content 4'],
    ),
    ProductCategory(
      title: 'Dairy',
      imagePath: 'asset/images/foodgrain.jpg',
      dropdownContent: ['Dropdown Content 5', 'Dropdown Content 6'],
    ),
    ProductCategory(
      title: 'shampoo',
      imagePath: 'asset/images/foodgrain.jpg',
      dropdownContent: ['Dropdown Content 5', 'Dropdown Content 6'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: GColors.primary,
        title: Text(
          'Categories',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon:  Icon(
              Icons.favorite_outline,
              size: GSizes.iconMd,
              color: GColors.black,
            ),
          ),
          const SizedBox(width: 10),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return badges.Badge(
                badgeContent: Text(
                  cart.itemCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ),
                    );
                  },
                  child:  Icon(
                    Icons.shopping_cart_outlined,
                    size: GSizes.iconMd,
                    color: GColors.black,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(
                top: GSizes.sm, left: GSizes.sm, right: GSizes.sm),
            child: Card(
              color: GColors.accent,
              child: ExpansionTile(
                title: Row(
                  children: [
                    Image.asset(
                      category.imagePath,
                      width: 130,
                      height: 120,
                    ),
                    const Padding(padding: EdgeInsets.only(left: GSizes.xl)),
                    Expanded(
                      child: Text(
                        category.title,
                        style:  TextStyle(
                            color: GColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: GSizes.fontSizeXl),
                      ),
                    ),
                  ],
                ),
                children: category.dropdownContent.map((content) {
                  return Container(
                    padding: const EdgeInsets.only(top: GSizes.md, bottom: GSizes.sm),
                    color: GColors.accent,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                content,
                                style:  TextStyle(fontSize: GSizes.fontSizeMd),
                              ),
                            ),
                            const Spacer(),
                             Icon(
                              Icons.arrow_forward_ios,
                              size: GSizes.iconSm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductCategory {
  final String title;
  final String imagePath;
  final List<String> dropdownContent;

  ProductCategory({
    required this.title,
    required this.imagePath,
    required this.dropdownContent,
  });
}
