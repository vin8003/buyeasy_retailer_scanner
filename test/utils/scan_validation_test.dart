import 'package:flutter_test/flutter_test.dart';
import 'package:buyeasy_retailer_scanner/utils/scan_validation.dart';

void main() {
  group('ScanValidation.barcodeError', () {
    test('blocks empty and whitespace-only barcodes', () {
      expect(
        ScanValidation.barcodeError(''),
        ScanValidation.blankBarcodeMessage,
      );
      expect(
        ScanValidation.barcodeError('   '),
        ScanValidation.blankBarcodeMessage,
      );
      expect(
        ScanValidation.barcodeError(null),
        ScanValidation.blankBarcodeMessage,
      );
    });

    test('accepts a trimmed barcode', () {
      expect(ScanValidation.barcodeError('  890123  '), isNull);
      expect(ScanValidation.normalizeBarcode('  890123  '), '890123');
    });
  });

  group('ScanValidation.displayString', () {
    test('coerces null and non-string lookup values without throwing', () {
      expect(ScanValidation.displayString(null), '');
      expect(ScanValidation.displayString('Soap'), 'Soap');
      expect(ScanValidation.displayString(12.5), '12.5');
      expect(ScanValidation.displayString(99), '99');
    });
  });
}
