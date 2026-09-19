class ScanValidation {
  static const String blankBarcodeMessage = 'Barcode is required';

  static String normalizeBarcode(String? raw) => (raw ?? '').trim();

  static String? barcodeError(String? raw) {
    if (normalizeBarcode(raw).isEmpty) {
      return blankBarcodeMessage;
    }
    return null;
  }

  static String displayString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}
