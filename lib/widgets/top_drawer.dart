import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/main.dart';
import 'package:e_mart/pages/profile_page.dart';
import 'package:e_mart/pages/welcome/register_page.dart';
import 'package:e_mart/pages/wishlist_page.dart';
import 'package:e_mart/pages/delete_acc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TopDrawer extends StatefulWidget {
  const TopDrawer({super.key});

  @override
  _TopDrawerState createState() => _TopDrawerState();
}

class _TopDrawerState extends State<TopDrawer> {
  String name = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  /// **Fetch User Profile with JWT**
  Future<void> fetchUserProfile() async {
    try {
      String? token = await storage1.read(key: "token");
      if (token == null) {
        print("❌ No token found");
        return;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted && data['success'] == true && data['user'] != null) {
          setState(() {
            name = data['user']['username'] ?? "No name";
            email = data['user']['email'] ?? "No email";
          });
        }
        print("✅ Profile fetched successfully: ${response.body}");
      } else {
        print("❌ Error ${response.statusCode}: ${response.body}");
        if (mounted) {
          setState(() {
            name = "Error loading";
            email = "Please try again";
          });
        }
      }
    } catch (e) {
      print("❌ Exception: $e");
      if (mounted) {
        setState(() {
          name = "Error loading";
          email = "Please check connection";
        });
      }
    }
  }

  /// **Sign Out and Remove Token**
  Future<void> signOut(BuildContext context) async {
    await storage1.delete(key: "token");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 1,
      elevation: 10,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: GColors.primary),
            accountName: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: Text(
                name.isNotEmpty ? name : "Loading...",
                style: TextStyle(
                  fontSize: GSizes.fontSizeLg1,
                  fontWeight: FontWeight.w500,
                  color: GColors.textPrimary,
                ),
              ),
            ),
            accountEmail: Text(
              email.isNotEmpty ? email : "Loading...",
              style: TextStyle(
                fontSize: GSizes.fontSizeSm,
                fontWeight: FontWeight.w400,
                color: GColors.textPrimary,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : "?",
                style: TextStyle(
                  fontSize: GSizes.fontSizeLg1,
                  fontWeight: FontWeight.bold,
                  color: GColors.primary,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: GSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                color: GColors.textPrimary,
              ),
            ),
            leading: Icon(Icons.edit, size: GSizes.iconMd, color: GColors.iconPrimary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const Divider(height: 10),
          ListTile(
            title: Text(
              'My Orders',
              style: TextStyle(
                fontSize: GSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                color: GColors.textPrimary,
              ),
            ),
            leading: Icon(Icons.shopping_bag_rounded, size: GSizes.iconMd, color: GColors.iconPrimary),
          ),
          const Divider(height: 10),
          ListTile(
            title: Text(
              'My Wishlist',
              style: TextStyle(
                fontSize: GSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                color: GColors.textPrimary,
              ),
            ),
            leading: Icon(Icons.favorite_outline_rounded, size: GSizes.iconMd, color: GColors.iconPrimary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistPage()),
              );
            },
          ),
          const Divider(height: 10),
          ListTile(
            title: Text(
              'Terms Of Use',
              style: TextStyle(
                fontSize: GSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                color: GColors.textPrimary,
              ),
            ),
            leading: Icon(Icons.remove_done, size: GSizes.iconMd, color: GColors.iconPrimary),
          ),
          const Divider(height: 10),
          ListTile(
            title: Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: GSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                color: GColors.textPrimary,
              ),
            ),
            leading: Icon(Icons.remove_done, size: GSizes.iconMd, color: GColors.iconPrimary),
          ),
          const Divider(height: 10),
          ListTile(
            title: Text(
              'Delete Account',
              style: TextStyle(
                fontSize: GSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                color: GColors.textPrimary,
              ),
            ),
            leading: Icon(Icons.delete, size: GSizes.iconMd, color: GColors.iconPrimary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  DeleteAcc()),
              );
            },
          ),
          const Divider(height: 10),
          ListTile(
            onTap: () => signOut(context),
            title: Text(
              'Sign Out',
              style: TextStyle(
                fontSize: GSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                color: GColors.textPrimary,
              ),
            ),
            leading: Icon(Icons.logout, size: GSizes.iconMd, color: GColors.iconPrimary),
          ),
          const Divider(height: 10),
          ListTile(
            title: Text(
              'Back',
              style: TextStyle(
                fontSize: GSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                color: GColors.textPrimary,
              ),
            ),
            leading: Icon(Icons.arrow_back, size: GSizes.iconMd, color: GColors.iconPrimary),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(height: 10),
        ],
      ),
    );
  }
}
