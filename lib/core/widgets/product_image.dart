import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'type_icon.dart';

// Shows the product image, falling back to a type icon if it is missing.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.sku,
    required this.type,
    this.size,
    this.fit = BoxFit.cover,
  });

  final String sku;
  final String type;
  final double? size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/products/$sku.jpg',
      width: size,
      height: size,
      fit: fit,
      errorBuilder: (context, error, stack) => Container(
        width: size,
        height: size,
        color: AppColors.panelLight,
        alignment: Alignment.center,
        child: Icon(
          iconForType(type),
          color: AppColors.cyan,
          size: size != null ? size! * 0.5 : 40,
        ),
      ),
    );
  }
}
