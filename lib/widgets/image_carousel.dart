import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  ImageCarousel({super.key});

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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 210.0,
          autoPlay: true, // Enables auto-scrolling
          autoPlayInterval: Duration(seconds: 3), // Time between slides
          autoPlayAnimationDuration: Duration(milliseconds: 800), // Smooth transition
          autoPlayCurve: Curves.easeInOut,
          enlargeCenterPage: true,
          enableInfiniteScroll: true, 
          viewportFraction: 0.85, 
        ),
        items: listImages.map((imagePath) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        }).toList(),
      ),
    );
  }
}
