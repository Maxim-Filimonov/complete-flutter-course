import 'dart:math';

import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app/src/common_widgets/my_shimmer.dart';
import 'package:ecommerce_app/src/features/orders/presentation/orders_list/product_image.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/custom_image.dart';
import 'package:ecommerce_app/src/common_widgets/item_quantity_selector.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_two_column_layout.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_content_placeholder/flutter_content_placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Shows a shopping cart item (or loading/error UI if needed)
class ShoppingCartItem extends ConsumerWidget {
  const ShoppingCartItem({
    super.key,
    required this.item,
    required this.itemIndex,
    this.isEditable = true,
  });
  final Item item;
  final int itemIndex;

  /// if true, an [ItemQuantitySelector] and a delete button will be shown
  /// if false, the quantity will be shown as a read-only label (used in the
  /// [PaymentPage])
  final bool isEditable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productStreamProvider(item.productId));
    return AsyncValueWidget(
      value: productValue,
      loading: () => MyShimmer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: ShoppingCartItemContents(
              product: null,
              item: item,
              itemIndex: itemIndex,
              isEditable: isEditable,
            ),
          ),
        ),
      ),
      data: (product) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: ShoppingCartItemContents(
              product: product,
              item: item,
              itemIndex: itemIndex,
              isEditable: isEditable,
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows a shopping cart item for a given product
class ShoppingCartItemContents extends StatelessWidget {
  const ShoppingCartItemContents({
    super.key,
    required this.product,
    required this.item,
    required this.itemIndex,
    required this.isEditable,
  });
  final Product? product;
  final Item item;
  final int itemIndex;
  final bool isEditable;

  // * Keys for testing using find.byKey()
  static Key deleteKey(int index) => Key('delete-$index');

  @override
  Widget build(BuildContext context) {
    // TODO: error handling
    // TODO: Inject formatter
    return ResponsiveTwoColumnLayout(
      startFlex: 1,
      endFlex: 2,
      breakpoint: 320,
      startContent: ProductImage(product: product),
      spacing: Sizes.p24,
      endContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProductTitle(product: product),
          gapH24,
          ProductPrice(
            product: product,
          ),
          gapH24,
          ProductQuantity(
            product: product,
            isEditable: isEditable,
            item: item,
            itemIndex: itemIndex,
          ),
        ],
      ),
    );
  }
}

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    super.key,
    required this.product,
  });

  final Product? product;

  @override
  Widget build(BuildContext context) {
    final product = this.product;
    if (product != null) {
      final priceFormatted =
          NumberFormat.simpleCurrency().format(product.price);
      return Text(priceFormatted,
          style: Theme.of(context).textTheme.headlineSmall);
    } else {
      return const ContentPlaceholder(
        height: 20,
        width: 100,
      );
    }
  }
}

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
      return Text(product.title,
          style: Theme.of(context).textTheme.headlineSmall);
    } else {
      return const ContentPlaceholder(
        height: 20,
        width: 100,
      );
    }
  }
}

class ProductQuantity extends StatelessWidget {
  const ProductQuantity({
    super.key,
    required this.product,
    required this.isEditable,
    required this.item,
    required this.itemIndex,
  });

  final Product? product;
  final bool isEditable;
  final Item item;
  final int itemIndex;

  static Key deleteKey(int index) => Key('delete-$index');

  @override
  Widget build(BuildContext context) {
    final product = this.product;
    if (product != null) {
      return isEditable
          // show the quantity selector and a delete button
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ItemQuantitySelector(
                  quantity: item.quantity,
                  maxQuantity: min(product.availableQuantity, 10),
                  itemIndex: itemIndex,
                  // TODO: Implement onChanged
                  onChanged: (value) {
                    showNotImplementedAlertDialog(context: context);
                  },
                ),
                IconButton(
                  key: deleteKey(itemIndex),
                  icon: Icon(Icons.delete, color: Colors.red[700]),
                  // TODO: Implement onPressed
                  onPressed: () {
                    showNotImplementedAlertDialog(context: context);
                  },
                ),
                const Spacer(),
              ],
            )
          // else, show the quantity as a read-only label
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
              child: Text(
                'Quantity: ${item.quantity}'.hardcoded,
              ),
            );
    } else {
      return ContentPlaceholder.block(context: context, height: 40);
    }
  }
}
