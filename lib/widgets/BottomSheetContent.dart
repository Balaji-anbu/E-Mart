import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'geolocation_service.dart';


class BottomSheetContent extends StatefulWidget {
  final GeolocationService geolocationService;
  final ValueNotifier<String> addressNotifier;

  BottomSheetContent({
    required this.geolocationService,
    required this.addressNotifier,
  });

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late TextEditingController _pincodeController;

  @override
  void initState() {
    super.initState();
    _pincodeController = TextEditingController();
    _pincodeController.text = widget.addressNotifier.value;
  }

  Future<void> _updateAddressFromPincode() async {
    String pincode = _pincodeController.text;
    if (pincode.isNotEmpty) {
      try {
        List<Location> locations = await widget.geolocationService.getLocationFromPincode(pincode);
        if (locations.isNotEmpty) {
          Location location = locations.first;
          String address = await widget.geolocationService.getAddressFromCoordinates(
            location.latitude,
            location.longitude,
          );
          setState(() {
            widget.addressNotifier.value = '$address, $pincode';
            _pincodeController.text = widget.addressNotifier.value;
          });
        } else {
          setState(() {
            widget.addressNotifier.value = 'No address found for this pincode.';
            _pincodeController.text = widget.addressNotifier.value;
          });
        }
      } catch (e) {
        setState(() {
          widget.addressNotifier.value = 'Error: $e';
          _pincodeController.text = widget.addressNotifier.value;
        });
      }
    }
  }

  Future<void> _updateAddressFromCurrentLocation() async {
    try {
      Position position = await widget.geolocationService.getCurrentLocation();
      String address = await widget.geolocationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
      setState(() {
        widget.addressNotifier.value = address;
        _pincodeController.text = address;
      });
    } catch (e) {
      setState(() {
        widget.addressNotifier.value = 'Error: $e';
        _pincodeController.text = widget.addressNotifier.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _pincodeFocusNode = FocusNode();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: GColors.iconPrimary,size: GSizes.iconMd1,),
                  const SizedBox(width: 10),
                  Text(
                    'Change Location',
                    style: TextStyle(fontSize: GSizes.fontSizeXl1, fontWeight: FontWeight.w500, color: GColors.textPrimary),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.cancel,color: GColors.iconPrimary,size: GSizes.iconMd1,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Choose a delivery location to see product availability and delivery options',
                style: TextStyle(fontSize: GSizes.fontSizeSm1, color: GColors.textPrimary),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pincodeController,
                focusNode: _pincodeFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter pincode",
                  labelStyle: TextStyle(
                    color: _pincodeFocusNode.hasFocus ? GColors.primary : GColors.primary,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: GColors.primary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: GColors.primary),
                  ),
                  suffixIcon: TextButton(
                    onPressed: _updateAddressFromPincode,
                    child:  Text('Change', style: TextStyle(color: GColors.primary,fontWeight: FontWeight.w600,fontSize: GSizes.fontSizeSm1)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _updateAddressFromCurrentLocation,
                child:  Row(
                  children: [
                    Icon(Icons.my_location, color: GColors.primary,size: GSizes.iconMd1,),
                    SizedBox(width: 10),
                    Text(
                      "Use your current location",
                      style: TextStyle(color: GColors.primary, fontWeight: FontWeight.bold, fontSize: GSizes.fontSizeLg),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}