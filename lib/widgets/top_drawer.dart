import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/pages/profile_page.dart';
import 'package:e_mart/pages/wishlist_page.dart';
import 'package:e_mart/pages/delete_acc.dart';
import 'package:flutter/material.dart';

class TopDrawer extends StatelessWidget {
  const TopDrawer({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 20,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: GColors.primary),
            accountName: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ));
              },
              child: Text(
                'Fasheena',
                style: TextStyle(fontSize: GSizes.fontSizeLg1, fontWeight: FontWeight.w500, color: GColors.textPrimary),
              ),
            ),
            accountEmail: Text(
              'fasheenarca20@gmail.com',
              style: TextStyle(fontSize: GSizes.fontSizeSm, fontWeight: FontWeight.w400, color: GColors.textPrimary),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('asset/images/foodgrain.jpg'),
            ),
            // otherAccountsPictures: <Widget>[
            //   CircleAvatar(
            //     backgroundImage: AssetImage('asset/images/foodgrain.jpg'),
            //   ),
            // ],
          ),
          ListTile(
              title: Text(
                'Edit Profile',
                style: TextStyle(fontSize: GSizes.fontSizeMd, fontWeight: FontWeight.w500, color: GColors.textPrimary),
              ),
              leading:  Icon(Icons.edit,size: GSizes.iconMd,color: GColors.iconPrimary,),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ));
              }),
          const Divider(
            height: 10,
          ),
          ListTile(
            title: Text(
              'My Orders',
              style: TextStyle(fontSize: GSizes.fontSizeMd, fontWeight: FontWeight.w500, color: GColors.textPrimary),
            ),
            leading:  Icon(Icons.shopping_bag_rounded,size: GSizes.iconMd,color: GColors.iconPrimary,),
          ),
          const Divider(
            height: 10,
          ),
          ListTile(
            title: Text(
              'My Wishlist',
              style: TextStyle(fontSize: GSizes.fontSizeMd, fontWeight: FontWeight.w500, color: GColors.textPrimary),
            ),
            leading:  Icon(Icons.favorite_outline_rounded,size: GSizes.iconMd,color: GColors.iconPrimary,),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WishlistPage(),
                  ));
            },
          ),
          const Divider(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Terms Of Use',
              style: TextStyle(fontSize: GSizes.fontSizeMd, fontWeight: FontWeight.w500, color: GColors.textPrimary),
            ),
            leading:  Icon(Icons.remove_done,size: GSizes.iconMd,color: GColors.iconPrimary,),
          ),
          const Divider(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Privacy policy',
              style: TextStyle(fontSize: GSizes.fontSizeMd, fontWeight: FontWeight.w500, color: GColors.textPrimary),
            ),
            leading:  Icon(Icons.remove_done,size: GSizes.iconMd,color: GColors.iconPrimary,),
          ),
          const Divider(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Delete Account',
              style: TextStyle(fontSize: GSizes.fontSizeMd, fontWeight: FontWeight.w500, color: GColors.textPrimary),
            ),
            leading:  Icon(Icons.delete,size: GSizes.iconMd,color: GColors.iconPrimary,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeleteAcc(),
                ),
              );
            },
          ),
          const Divider(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Sign Out',
              style: TextStyle(fontSize: GSizes.fontSizeMd, fontWeight: FontWeight.w500, color: GColors.textPrimary),
            ),
            leading:  Icon(Icons.remove_done,size: GSizes.iconMd,color: GColors.iconPrimary,),
          ),
          const Divider(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Back',
              style: TextStyle(fontSize: GSizes.fontSizeMd, fontWeight: FontWeight.w500, color: GColors.textPrimary),
            ),
            leading:  Icon(Icons.arrow_back,size: GSizes.iconMd,color: GColors.iconPrimary,),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(
            height: 10,
          ),
        ],
      ),
    );
  }
}
