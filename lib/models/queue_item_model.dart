import 'dart:io';

class QueueItem {
  final String barcode;
  final File image;
  bool isUploading;
  bool isFailed;

  // Optional Details
  final String? name;
  final double? price;
  final double? mrp;
  final int? quantity;
  final String? productGroup;

  QueueItem({
    required this.barcode,
    required this.image,
    this.isUploading = false,
    this.isFailed = false,
    this.name,
    this.price,
    this.mrp,
    this.quantity,
    this.productGroup,
  });
}
