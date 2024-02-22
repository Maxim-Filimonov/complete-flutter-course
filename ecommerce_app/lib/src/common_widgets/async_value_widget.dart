import 'package:ecommerce_app/src/common_widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget(
      {super.key, required this.value, required this.data, this.loading});

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget Function()? loading;
  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (error, stack) => Center(
        child: ErrorMessageWidget(
          error.toString(),
        ),
      ),
      loading: () => loading?.call() ?? const DefaultLoadingSpinner(),
    );
  }
}

class DefaultLoadingSpinner extends StatelessWidget {
  const DefaultLoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
