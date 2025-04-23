// import 'package:e_mart/constants/colors.dart';
// import 'package:e_mart/constants/sizes.dart';
// import 'package:e_mart/pages/cart_page.dart';
// import 'package:e_mart/widgets/cart_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:badges/badges.dart' as badges;

// class categoriesPage extends StatelessWidget {
//   categoriesPage({super.key});

//   final List<ProductCategory> categories = [
//     ProductCategory(
//       title: 'Beverages',
//       imagePath: 'asset/images/foodgrain.jpg',
//       dropdownContent: ['Dropdown Content 1', 'Dropdown Content 2'],
//     ),
//     ProductCategory(
//       title: 'Snacks',
//       imagePath: 'asset/images/foodgrain.jpg',
//       dropdownContent: ['Dropdown Content 3', 'Dropdown Content 4'],
//     ),
//     ProductCategory(
//       title: 'Dairy',
//       imagePath: 'asset/images/foodgrain.jpg',
//       dropdownContent: ['Dropdown Content 5', 'Dropdown Content 6'],
//     ),
//     ProductCategory(
//       title: 'shampoo',
//       imagePath: 'asset/images/foodgrain.jpg',
//       dropdownContent: ['Dropdown Content 5', 'Dropdown Content 6'],
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 10,
//         backgroundColor: GColors.primary,
//         title: Text(
//           'Categories',
//           style: Theme.of(context).textTheme.headlineSmall,
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon:  Icon(
//               Icons.favorite_outline,
//               size: GSizes.iconMd,
//               color: GColors.black,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Consumer<Cart>(
//             builder: (context, cart, child) {
//               return badges.Badge(
//                 badgeContent: Text(
//                   cart.itemCount.toString(),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const CartPage(),
//                       ),
//                     );
//                   },
//                   child:  Icon(
//                     Icons.shopping_cart_outlined,
//                     size: GSizes.iconMd,
//                     color: GColors.black,
//                   ),
//                 ),
//               );
//             },
//           ),
//           const SizedBox(width: 20)
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           return Padding(
//             padding: const EdgeInsets.only(
//                 top: GSizes.sm, left: GSizes.sm, right: GSizes.sm),
//             child: Card(
//               color: GColors.accent,
//               child: ExpansionTile(
//                 title: Row(
//                   children: [
//                     Image.asset(
//                       category.imagePath,
//                       width: 130,
//                       height: 120,
//                     ),
//                     const Padding(padding: EdgeInsets.only(left: GSizes.xl)),
//                     Expanded(
//                       child: Text(
//                         category.title,
//                         style:  TextStyle(
//                             color: GColors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: GSizes.fontSizeXl),
//                       ),
//                     ),
//                   ],
//                 ),
//                 children: category.dropdownContent.map((content) {
//                   return Container(
//                     padding: const EdgeInsets.only(top: GSizes.md, bottom: GSizes.sm),
//                     color: GColors.accent,
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 content,
//                                 style:  TextStyle(fontSize: GSizes.fontSizeMd),
//                               ),
//                             ),
//                             const Spacer(),
//                              Icon(
//                               Icons.arrow_forward_ios,
//                               size: GSizes.iconSm,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ProductCategory {
//   final String title;
//   final String imagePath;
//   final List<String> dropdownContent;

//   ProductCategory({
//     required this.title,
//     required this.imagePath,
//     required this.dropdownContent,
//   });
// }


import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});

  final List<ProductCategory> categories = [
    ProductCategory(
      title: 'Beverages',
      icon: Icons.local_drink,
      color: Colors.blue.shade100,
      dropdownContent: [
        'Water & Soda', 
        'Juice & Smoothies', 
        'Tea & Coffee', 
        'Energy Drinks'
      ],
    ),
    ProductCategory(
      title: 'Snacks',
      icon: Icons.cookie,
      color: Colors.amber.shade100,
      dropdownContent: [
        'Chips & Crisps', 
        'Nuts & Seeds', 
        'Chocolates & Candies', 
        'Biscuits & Cookies'
      ],
    ),
    ProductCategory(
      title: 'Dairy',
      icon: Icons.egg_alt,
      color: Colors.green.shade100,
      dropdownContent: [
        'Milk & Cream', 
        'Cheese', 
        'Yogurt', 
        'Butter & Margarine'
      ],
    ),
    ProductCategory(
      title: 'Hair Care',
      icon: Icons.spa,
      color: Colors.purple.shade100,
      dropdownContent: [
        'Shampoo', 
        'Conditioner', 
        'Hair Oil', 
        'Hair Styling'
      ],
    ),
    ProductCategory(
      title: 'Personal Care',
      icon: Icons.face,
      color: Colors.pink.shade100,
      dropdownContent: [
        'Body Wash', 
        'Deodorants', 
        'Facial Care', 
        'Oral Care'
      ],
    ),
    ProductCategory(
      title: 'Household',
      icon: Icons.home,
      color: Colors.teal.shade100,
      dropdownContent: [
        'Cleaning Supplies', 
        'Laundry', 
        'Kitchen Essentials', 
        'Home Decor'
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GColors.primary,
        title: Text(
          'Categories',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white
          ),
        ),
        
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: GSizes.md, 
              vertical: GSizes.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(GSizes.sm),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: GSizes.md, 
                  vertical: GSizes.xs,
                ),
                childrenPadding: const EdgeInsets.only(
                  left: GSizes.lg, 
                  right: GSizes.lg, 
                  bottom: GSizes.md,
                ),
                title: Row(
                  children: [
                    // Category icon with container
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: category.color,
                        borderRadius: BorderRadius.circular(GSizes.sm),
                      ),
                      child: Icon(
                        category.icon,
                        size: 30,
                        color: category.color.withBlue(255).withGreen(100),
                      ),
                    ),
                    const SizedBox(width: GSizes.md),
                    
                    // Category title
                    Expanded(
                      child: Text(
                        category.title,
                        style: TextStyle(
                          color: GColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: GSizes.fontSizeLg,
                        ),
                      ),
                    ),
                  ],
                ),
                children: category.dropdownContent.map((content) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: GSizes.xs),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        content,
                        style: TextStyle(
                          fontSize: GSizes.fontSizeMd,
                          color: GColors.textPrimary,
                        ),
                      ),
                      trailing: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: GSizes.iconSm,
                          color: GColors.secondary,
                        ),
                      ),
                      onTap: () {
                        // Handle subcategory tap
                      },
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
  final IconData icon;
  final Color color;
  final List<String> dropdownContent;

  ProductCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.dropdownContent,
  });
}