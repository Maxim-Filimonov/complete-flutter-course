import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  FakeProductsRepository({this.delay = const Duration(seconds: 2)});

  final List<Product> _products = kTestProducts;
  final Duration delay;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _getProductOrNull(_products, id);
  }

  Product? _getProductOrNull(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> fetchProductsList() async {
    // if not in test mode
    await Future.delayed(delay);
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(delay);
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList()
        .map((products) => _getProductOrNull(products, id));
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  debugPrint("productsListStreamProvider");
  return ref.watch(productsRepositoryProvider).watchProductsList();
});
final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  return ref.watch(productsRepositoryProvider).fetchProductsList();
});

final productStreamProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  debugPrint("productStreamProvider");
  ref.onDispose(() {
    debugPrint("productStreamProvider disposed");
  });
  return ref.watch(productsRepositoryProvider).watchProduct(id);
});
