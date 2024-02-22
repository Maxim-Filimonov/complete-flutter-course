import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmer extends StatelessWidget {
  const MyShimmer({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.onSurface,
      highlightColor: Theme.of(context).colorScheme.surface,
      period: const Duration(seconds: 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
        child: child,
      ),
    );
  }
}
