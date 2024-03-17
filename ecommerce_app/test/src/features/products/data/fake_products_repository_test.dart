import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeProductsRepository', () {
    late FakeProductsRepository productsRepository;
    setUp(() {
      productsRepository = FakeProductsRepository(delay: Duration.zero);
    });

    test('getProductsList returns list of products', () async {
      expect(productsRepository.getProductsList(), kTestProducts);
    });

    test('getProduct(1) returns first product', () async {
      expect(productsRepository.getProduct('1'), kTestProducts.first);
    });

    test('getProduct(100) returns null', () async {
      expect(productsRepository.getProduct('100'), null);
    });

    test('fetchProductsList returns list of products', () async {
      expect(await productsRepository.fetchProductsList(), kTestProducts);
    });

    test('watchProductsList emits list of products', () {
      expect(
        productsRepository.watchProductsList(),
        emits(kTestProducts),
      );
    });

    test('watchProducts(1) emits first product', () {
      expect(
        productsRepository.watchProduct('1'),
        emits(kTestProducts.first),
      );
    });

    test('watchProducts(100) emits null', () {
      expect(
        productsRepository.watchProduct('100'),
        emits(null),
      );
    });
  });
}
