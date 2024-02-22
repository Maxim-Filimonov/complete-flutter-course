import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  final List<Product> _products = kTestProducts;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<List<Product>> fetchProductsList() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList()
        .map((products) => products.firstWhere((product) => product.id == id));
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
