import 'package:carousel_images/carousel_images.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
   ImageCarousel({
    super.key,
  });

  final List<String> listImages = [
    'asset/images/foodgrain.jpg',
    'asset/images/foodgrain.jpg',
    'asset/images/foodgrain.jpg',
    'asset/images/foodgrain.jpg',
    'asset/images/foodgrain.jpg',
    'asset/images/foodgrain.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10, bottom: 10, left: 5, right: 5),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: CarouselImages(
          scaleFactor: 0.7,
          listImages: listImages,
          height: 200.0,
          borderRadius: 30.0,
          cachedNetworkImage: true,
          verticalAlignment: Alignment.bottomCenter,
          onTap: (index) {
            print('Tapped on page $index');
          },
        )
      ),
    );
  }
}