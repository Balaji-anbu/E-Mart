import 'dart:io';
import 'package:e_mart/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = "John Doe";
  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: _name);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: GColors.primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final pickedImage =
                    await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _profileImage = pickedImage;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GColors.secondary
              ),
              child: const Text('Change Profile Picture',style: TextStyle(color: GColors.textSecondary),),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _name = nameController.text;
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: GColors.primary
            ),
            child: const Text('Save',style: TextStyle(color: GColors.textSecondary),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GColors.primary,
        title: const Text('My Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(File(_profileImage!.path))
                      : const AssetImage('images/default_profile.webp')
                          as ImageProvider, // Default image if no profile picture is selected
                ),
                const SizedBox(height: 10),
                Text(
                  _name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _editProfile,
                  icon: const Icon(Icons.edit, color: GColors.primary),
                  label: const Text('Edit Profile',
                      style: TextStyle(color: GColors.primary)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const Divider(),
          InkWell(
            child: const ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('My Orders', style: TextStyle(color: GColors.textPrimary)),
            ),
            onTap: () {
              Navigator.pushNamed(context, "myorder");
            },
          ),
          const Divider(color: Colors.grey),
          const ListTile(
            leading: Icon(Icons.favorite),
            title: Text('My Wishlist', style: TextStyle(color: GColors.textPrimary)),
          ),
          const Divider(color: Colors.grey),
          const ListTile(
            leading: Icon(Icons.payment),
            title: Text('My Payment', style: TextStyle(color:GColors.textPrimary)),
          ),
          const Divider(color: Colors.grey),
          const ListTile(
            leading: Icon(Icons.location_on),
            title: Text('My Addresses', style: TextStyle(color: GColors.textPrimary)),
          ),
          const Divider(color: Colors.grey),
          const ListTile(
            leading: Icon(Icons.delete),
            title:
                Text('Download Your records', style: TextStyle(color: GColors.textPrimary)),
          ),
          const Divider(),
          Center(
            child: Column(
              children: [
               
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: GColors.textSecondary,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Delete Account'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
