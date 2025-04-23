import 'package:flutter/material.dart';
import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/pages/categories_page.dart';

class PopularCategories extends StatelessWidget {
  const PopularCategories({super.key});

  // Define category data (name and icon)
  final List<Map<String, dynamic>> _categories = const [
    {'name': 'Grocery', 'icon': Icons.shopping_basket},
    {'name': 'Hair Care', 'icon': Icons.spa},
    {'name': 'Personal Care', 'icon': Icons.face},
    {'name': 'Household', 'icon': Icons.home},
    {'name': 'Health', 'icon': Icons.medication},
    {'name': 'Miscellaneous', 'icon': Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(GSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Popular Categories',
                style: TextStyle(
                  fontSize: GSizes.fontSizeXl1, 
                  fontWeight: FontWeight.w600, 
                  color: GColors.textPrimary,
                ),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(GSizes.borderRadiusSm),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, 
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'View all',
                        style: TextStyle(
                          fontSize: GSizes.fontSizeMd,
                          fontWeight: FontWeight.w500,
                          color: GColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: GColors.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: GSizes.spaceBtwItems),
          SizedBox(
            height: 120,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Modern styled category icon
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              GColors.secondary.withOpacity(0.1),
                              Colors.white,
                            ],
                          ),
                        ),
                        child: Icon(
                          _categories[index]['icon'],
                          size: 30,
                          color: GColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Category name
                      Text(
                        _categories[index]['name'],
                        style: TextStyle(
                          fontSize: GSizes.fontSizeSm,
                          fontWeight: FontWeight.w500,
                          color: GColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}