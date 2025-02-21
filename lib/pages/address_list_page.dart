import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/pages/base_stepper.dart';
import 'package:e_mart/pages/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:e_mart/pages/add_address_page.dart';

class AddressListPage extends StatefulWidget {
  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  List<Map<String, String>> addresses = [];

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    // Load addresses from SharedPreferences or another storage mechanism.
  }

  Future<void> saveAddresses() async {
    // Save the current list of addresses to SharedPreferences or another storage mechanism.
  }

  void addAddress(Map<String, String> newAddress) {
    setState(() {
      addresses.add(newAddress);
    });
    saveAddresses();
  }

  void editAddress(Map<String, String> updatedAddress, int index) {
    setState(() {
      addresses[index] = updatedAddress;
    });
    saveAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GColors.primary,
        foregroundColor: GColors.white,
        title: const Text('Delivery Address'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Add the BaseStepper below the AppBar
          BaseStepper(
            activeStep: 1, // Set the active step to indicate the current page
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: GColors.secondary,foregroundColor: GColors.white),
                    onPressed: () async {
                      final newAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddAddressPage(),
                        ),
                      );

                      if (newAddress != null) {
                        addAddress(newAddress);
                      }
                    },
                    child: const Text(
                      '+ Add New Address',
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        return AddressCard(
                          name: addresses[index]['name']!,
                          address: addresses[index]['address']!,
                          phone: addresses[index]['phone']!,
                          index: index,
                          onSave: editAddress,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final int index;
  final Function(Map<String, String>, int) onSave;

  const AddressCard({super.key,
    required this.name,
    required this.address,
    required this.phone,
    required this.index,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 5),
            Text(address, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            Text(phone, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    final editedAddress = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddAddressPage(
                          initialName: name,
                          initialAddress: address,
                          initialPhone: phone,
                        ),
                      ),
                    );

                    if (editedAddress != null) {
                      onSave(editedAddress, index);
                    }
                  },
                  child: const Text('Edit', style: TextStyle(color: GColors.secondary)),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: GColors.secondary,
                      foregroundColor: GColors.white,
                      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 50)),
                  child: const Text(
                    'Deliver to this Address',
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}