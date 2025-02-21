import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/pages/4th_page.dart';
import 'package:e_mart/pages/cart_page.dart';
import 'package:e_mart/pages/categories_page.dart';
import 'package:e_mart/pages/home_page.dart';
import 'package:e_mart/pages/wishlist_page.dart';
import 'package:e_mart/widgets/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;


class bottomPage extends StatefulWidget {
   const bottomPage({super.key});

  @override
  State<bottomPage> createState() => _bottomPageState();
}

class _bottomPageState extends State<bottomPage> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
     ForthPage(),
    categoriesPage(),
    HomePage(),
    WishlistPage(),
    const CartPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: GColors.primary,
        backgroundColor: GColors.textSecondary,
        height: 50,
        animationDuration: const Duration(milliseconds: 300),
        onTap: _onItemTapped,
        index: _selectedIndex,
        items: <Widget>[
           Icon(
            Icons.favorite_outline_rounded,
            size: GSizes.iconMd,
            color: GColors.button,
          ),
           Icon(
            Icons.toc,
            size: GSizes.iconMd,
            color: GColors.button,
          ),
           Icon(
            Icons.home,
            size: GSizes.iconMd,
            color: GColors.button,
          ),
           Icon(
            Icons.favorite_outline_rounded,
            size: GSizes.iconMd,
            color: GColors.button,
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return badges.Badge(
                position: badges.BadgePosition.topEnd(top: -16, end: -9),
                badgeContent: Text(
                  cart.itemCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child:  Icon(
                  Icons.shopping_cart_outlined,
                  size: GSizes.iconMd,
                  color: GColors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
