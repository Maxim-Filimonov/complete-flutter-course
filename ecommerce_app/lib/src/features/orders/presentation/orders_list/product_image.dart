import 'package:ecommerce_app/src/common_widgets/custom_image.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_content_placeholder/flutter_content_placeholder.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
  });

  final Product? product;

  @override
  Widget build(BuildContext context) {
    final product = this.product;
    if (product != null) {
      return CustomImage(imageUrl: product.imageUrl);
    } else {
      return ContentPlaceholder.block(
        context: context,
        height: 80,
        width: 80,
      );
    }
  }
}
