import 'package:flutter/material.dart';
import 'package:e_mart/constants/colors.dart';

enum BadgeType { trending, bestSeller, none }

class ProductBadge extends StatelessWidget {
  final BadgeType type;
  
  const ProductBadge({Key? key, required this.type}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (type == BadgeType.none) return const SizedBox.shrink();
    
    // Badge configurations
    final bool isTrending = type == BadgeType.trending;
    final Color badgeColor = isTrending ? Colors.blueAccent : GColors.secondary;
    final String badgeText = isTrending ? 'Trending' : 'Best Seller';
    final IconData badgeIcon = isTrending 
        ? Icons.trending_up_rounded 
        : Icons.star_rounded;

    return Positioned(
      top: 1,
      left: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: badgeColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              badgeIcon,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              badgeText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}