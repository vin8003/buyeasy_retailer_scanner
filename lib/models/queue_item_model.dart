import 'dart:io';

class QueueItem {
  final String barcode;
  final File image;
  bool isUploading;
  bool isFailed;

  QueueItem({
    required this.barcode,
    required this.image,
    this.isUploading = false,
    this.isFailed = false,
  });
}
