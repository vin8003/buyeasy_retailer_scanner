import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:buyeasy_retailer_scanner/models/product_model.dart';

void main() {
  group('Product.fromJson', () {
    test('does not crash when price and quantity are null', () {
      final json = jsonDecode(
        File('test/fixtures/product_null_price.json').readAsStringSync(),
      ) as Map<String, dynamic>;

      final product = Product.fromJson(json);

      expect(product.id, 42);
      expect(product.name, 'Test Rice 1kg');
      expect(product.price, 0);
      expect(product.quantity, 0);
      expect(product.unit, 'piece');
      expect(product.categoryName, 'Groceries');
      expect(product.brandName, isNull);
    });

    test('does not crash when required fields are missing', () {
      final product = Product.fromJson(const {});

      expect(product.id, 0);
      expect(product.name, '');
      expect(product.description, '');
      expect(product.price, 0);
      expect(product.quantity, 0);
      expect(product.unit, 'piece');
    });

    test('parses numeric and string prices the backend actually sends', () {
      expect(Product.fromJson({'price': 12}).price, 12);
      expect(Product.fromJson({'price': 12.5}).price, 12.5);
      expect(Product.fromJson({'price': '19.99'}).price, 19.99);
      expect(Product.fromJson({'price': ''}).price, 0);
      expect(Product.fromJson({'price': 'not-a-number'}).price, 0);
    });

    test('parses string ids and decimal quantities without type errors', () {
      final product = Product.fromJson({
        'id': '7',
        'name': 100,
        'quantity': '3',
        'unit': 'kg',
      });

      expect(product.id, 7);
      expect(product.name, '100');
      expect(product.quantity, 3);
      expect(product.unit, 'kg');
    });
  });
}
