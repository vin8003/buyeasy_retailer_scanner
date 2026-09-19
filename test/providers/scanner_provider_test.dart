import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:buyeasy_retailer_scanner/models/upload_session_model.dart';
import 'package:buyeasy_retailer_scanner/providers/scanner_provider.dart';
import 'package:buyeasy_retailer_scanner/services/product_service.dart';
import 'package:buyeasy_retailer_scanner/utils/scan_validation.dart';

class _FakeProductService extends ProductService {
  _FakeProductService({this.failNext = false});

  bool failNext;
  int addCalls = 0;
  final uploadedBarcodes = <String>[];

  @override
  Future<ProductUploadSession> createUploadSession(
    String token, {
    String? name,
  }) async {
    return ProductUploadSession(
      id: 42,
      name: name ?? 'Test',
      status: 'active',
      createdAt: DateTime.utc(2026, 9, 18),
      items: [],
    );
  }

  @override
  Future<UploadSessionItem> addSessionItem(
    String token,
    int sessionId,
    String barcode,
    File? image, {
    Map<String, dynamic>? details,
  }) async {
    addCalls++;
    if (failNext) {
      failNext = false;
      throw Exception('upload failed');
    }
    uploadedBarcodes.add(barcode);
    return UploadSessionItem(id: addCalls, barcode: barcode);
  }
}

void main() {
  late File imageFile;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    imageFile = File(
      '${Directory.systemTemp.path}/scanner_queue_${DateTime.now().microsecondsSinceEpoch}.jpg',
    );
    await imageFile.writeAsBytes([0xFF, 0xD8, 0xFF]);
  });

  tearDown(() async {
    if (imageFile.existsSync()) {
      await imageFile.delete();
    }
  });

  test('addItemToQueue rejects a blank barcode before enqueue', () async {
    final service = _FakeProductService();
    final provider = ScannerProvider(productService: service);
    await provider.startSession('token', name: 'Aisle');

    expect(
      () => provider.addItemToQueue('token', '   ', imageFile),
      throwsA(
        isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          ScanValidation.blankBarcodeMessage,
        ),
      ),
    );
    expect(provider.pendingCount, 0);
    expect(service.addCalls, 0);
  });

  test(
    'failed upload moves the item to failedQueue instead of getting stuck',
    () async {
      final service = _FakeProductService(failNext: true);
      final provider = ScannerProvider(productService: service);
      await provider.startSession('token');

      provider.addItemToQueue('token', '890111', imageFile);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(provider.pendingCount, 0);
      expect(provider.failedQueue, hasLength(1));
      expect(provider.failedQueue.first.barcode, '890111');
      expect(provider.failedQueue.first.isFailed, isTrue);
    },
  );

  test('retryFailedItem requeues and uploads', () async {
    final service = _FakeProductService(failNext: true);
    final provider = ScannerProvider(productService: service);
    await provider.startSession('token');

    provider.addItemToQueue('token', '890222', imageFile);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(provider.failedQueue, hasLength(1));

    provider.retryFailedItem('token', provider.failedQueue.first);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(provider.failedQueue, isEmpty);
    expect(provider.pendingCount, 0);
    expect(service.uploadedBarcodes, ['890222']);
  });
}
