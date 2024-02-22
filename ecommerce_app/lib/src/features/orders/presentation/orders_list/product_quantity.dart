import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_content_placeholder/flutter_content_placeholder.dart';

class ProductQuantity extends StatelessWidget {
  const ProductQuantity({
    super.key,
    required this.item,
    required this.product,
  });

  final Item item;
  final Product? product;

  @override
  Widget build(BuildContext context) {
    final product = this.product;
    if (product != null) {
      return Text(
        'Quantity: ${item.quantity}'.hardcoded,
        style: Theme.of(context).textTheme.bodySmall,
      );
    } else {
      return const ContentPlaceholder(
        width: 50.0,
        height: 10.0,
      );
    }
  }
}
