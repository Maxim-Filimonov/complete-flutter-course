import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_content_placeholder/flutter_content_placeholder.dart';

class ProductTitle extends StatelessWidget {
  const ProductTitle({
    super.key,
    required this.product,
  });

  final Product? product;

  @override
  Widget build(BuildContext context) {
    final product = this.product;
    if (product != null) {
      return Text(product.title);
    } else {
      return const ContentPlaceholder(
        width: 50.0,
        height: 10.0,
      );
    }
  }
}
