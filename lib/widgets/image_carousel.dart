import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  ImageCarousel({super.key});

  final List<String> listImages = [
    'asset/images/test1.jpg',
    'asset/images/test2.jpg',
    'asset/images/test3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: CarouselSlider(
        
        options: CarouselOptions(
          height: 220,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 900),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          viewportFraction: 1,
        ),
        items: listImages.map((imagePath) {
          return Builder(
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imagePath,
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    // Optional caption text (can remove if not needed)
                    // Positioned(
                    //   bottom: 10,
                    //   left: 15,
                    //   child: Text(
                    //     'Caption Here',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
