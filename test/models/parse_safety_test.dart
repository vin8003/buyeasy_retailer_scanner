import 'package:flutter_test/flutter_test.dart';
import 'package:buyeasy_retailer_scanner/models/product_model.dart';
import 'package:buyeasy_retailer_scanner/models/upload_session_model.dart';

void main() {
  group('Product.fromJson', () {
    test('does not crash when price or name is null', () {
      final product = Product.fromJson({'id': 7, 'name': null, 'price': null});

      expect(product.id, 7);
      expect(product.name, '');
      expect(product.price, 0);
    });
  });

  group('UploadSessionItem.fromJson', () {
    test('does not crash when barcode or product_details is null', () {
      final item = UploadSessionItem.fromJson({
        'id': 3,
        'barcode': null,
        'image': null,
        'product_details': null,
      });

      expect(item.id, 3);
      expect(item.barcode, '');
      expect(item.productDetails, isEmpty);
    });

    test('accepts a non-map product_details payload', () {
      final item = UploadSessionItem.fromJson({
        'id': 4,
        'barcode': '111',
        'product_details': 'not-a-map',
      });

      expect(item.barcode, '111');
      expect(item.productDetails, isEmpty);
    });
  });

  group('ProductUploadSession.fromJson', () {
    test('does not crash when created_at or status is missing', () {
      final session = ProductUploadSession.fromJson({
        'id': 9,
        'name': 'Counter',
      });

      expect(session.id, 9);
      expect(session.status, isNotEmpty);
      expect(session.items, isEmpty);
    });

    test('skips malformed items instead of throwing', () {
      final session = ProductUploadSession.fromJson({
        'id': 2,
        'status': 'active',
        'created_at': '2026-09-18T10:00:00Z',
        'items': [
          {'id': 1, 'barcode': 'ABC'},
          'bad-row',
          null,
        ],
      });

      expect(session.items, hasLength(1));
      expect(session.items.first.barcode, 'ABC');
    });
  });

  group('ProductUploadSession.fromDetailsResponse', () {
    test('throws a FormatException when session key is null', () {
      expect(
        () => ProductUploadSession.fromDetailsResponse({'session': null}),
        throwsA(isA<FormatException>()),
      );
    });

    test('parses the nested session object', () {
      final session = ProductUploadSession.fromDetailsResponse({
        'session': {
          'id': 11,
          'name': 'Stock',
          'status': 'active',
          'created_at': '2026-09-18T10:00:00Z',
          'items': [],
        },
      });

      expect(session.id, 11);
      expect(session.name, 'Stock');
    });
  });
}
