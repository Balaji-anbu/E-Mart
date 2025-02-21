import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/constants/sizes.dart';
import 'package:e_mart/pages/categories_page.dart';
import 'package:flutter/material.dart';

class PopularCategories extends StatelessWidget {
  const PopularCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(GSizes.sm),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'popular categories',
                style: TextStyle(fontSize: GSizes.fontSizeXl1, fontWeight: FontWeight.w500, color: GColors.textPrimary),
              ),
              const Spacer(),
              GestureDetector(
                child:  Text(
                  'view all',
                  style: TextStyle(
                      fontSize: GSizes.fontSizeMd,
                      fontWeight: FontWeight.w500,
                      color: GColors.secondary),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => categoriesPage(),
                      ));
                },
              ),
            ],
          ),
          SizedBox(
            height: 100,
            child:ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProfileAvatar(
                      '',
                      borderColor: Colors.transparent,
                      borderWidth: 1,
                      elevation: 1,
                      radius: 30,
                      imageFit: BoxFit.contain,
                      child: Image.asset('asset/images/vegetable.png'),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}