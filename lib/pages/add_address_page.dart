import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/widgets/geolocation_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AddAddressPage extends StatefulWidget {
  final String? initialName;
  final String? initialAddress;
  final String? initialPhone;

  const AddAddressPage({
    this.initialName,
    this.initialAddress,
    this.initialPhone,
  });

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final GeolocationService _geolocationService = GeolocationService();

  TextEditingController houseController = TextEditingController();
  TextEditingController roadController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController famousPlaceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) {
      nameController.text = widget.initialName!;
    }
    if (widget.initialAddress != null) {
      // Split the address into respective fields
      List<String> addressParts = widget.initialAddress!.split(', ');
      if (addressParts.length >= 5) {
        houseController.text = addressParts[0];
        roadController.text = addressParts[1];
        cityController.text = addressParts[2];
        stateController.text = addressParts[3];
        pincodeController.text = addressParts[4];
      }
    }
    if (widget.initialPhone != null) {
      phoneController.text = widget.initialPhone!;
    }
  }

  void fillAddressFields(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        houseController.text = place.name ?? '';
        roadController.text = place.street ?? '';
        pincodeController.text = place.postalCode ?? '';
        cityController.text = place.locality ?? '';
        stateController.text = place.administrativeArea ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GColors.primary,
        foregroundColor: GColors.white,
        title: const Text('Add Delivery Address'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Position position = await _geolocationService.getCurrentLocation();
                      fillAddressFields(position);
                    },
                    icon: const Icon(Icons.my_location),
                    label: const Text('Use My Location'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      backgroundColor: GColors.secondary,
                      foregroundColor: GColors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                cursorColor: GColors.black,
                controller: houseController,
                decoration: const InputDecoration(
                  labelText: 'House no./ Building Name',
                  labelStyle: TextStyle(fontSize: 15,color: GColors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: GColors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                cursorColor: GColors.black,
                controller: roadController,
                decoration: const InputDecoration(
                  labelText: 'Road Name / Area / Colony',
                  labelStyle: TextStyle(fontSize: 15,color: GColors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: GColors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      cursorColor: GColors.black,
                      controller: pincodeController,
                      decoration: const InputDecoration(
                        labelText: 'Pincode',
                        labelStyle: TextStyle(fontSize: 15,color: GColors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: GColors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      cursorColor: GColors.black,
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(fontSize: 15,color: GColors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: GColors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                cursorColor: GColors.black,
                controller: stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  labelStyle: TextStyle(fontSize: 15,color: GColors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: GColors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                cursorColor: GColors.black,
                controller: famousPlaceController,
                decoration: const InputDecoration(
                  labelText: 'Nearby Famous Place/Shop/School, etc. (optional)',
                  labelStyle: TextStyle(fontSize: 15,color: GColors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: GColors.black),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                cursorColor: GColors.black,
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontSize: 15,color: GColors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: GColors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                cursorColor: GColors.black,
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  labelStyle: TextStyle(fontSize: 15,color: GColors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: GColors.black),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final editedAddress = {
                        'name': nameController.text,
                        'address': '${houseController.text}, ${roadController.text}, ${cityController.text}, ${stateController.text}, ${pincodeController.text}',
                        'phone': phoneController.text,
                      };
                      Navigator.pop(context, editedAddress);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                    foregroundColor: GColors.white,
                  ),
                  child:  const Text('Save Address and Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

