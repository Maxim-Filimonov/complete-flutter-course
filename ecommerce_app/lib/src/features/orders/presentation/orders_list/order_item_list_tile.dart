import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app/src/common_widgets/my_shimmer.dart';
import 'package:ecommerce_app/src/features/orders/presentation/orders_list/product_image.dart';
import 'package:ecommerce_app/src/features/orders/presentation/orders_list/product_quantity.dart';
import 'package:ecommerce_app/src/features/orders/presentation/orders_list/product_title.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/custom_image.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:flutter_content_placeholder/flutter_content_placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows an individual order item, including price and quantity.
class OrderItemListTile extends ConsumerWidget {
  const OrderItemListTile({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productStreamProvider(item.productId));
    return AsyncValueWidget(
      value: productValue,
      loading: () => MyShimmer(
        child: ItemDetails(item: item, product: null),
      ),
      data: (product) => ItemDetails(item: item, product: product!),
    );
  }
}

class ItemDetails extends StatelessWidget {
  const ItemDetails({
    super.key,
    required this.item,
    required this.product,
  });

  final Item item;
  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Row(
        children: [
          Flexible(flex: 1, child: ProductImage(product: product)),
          gapW8,
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductTitle(product: product),
                gapH12,
                ProductQuantity(item: item, product: product),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
