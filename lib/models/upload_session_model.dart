class UploadSessionItem {
  final int? id;
  final String barcode;
  final String? imageUrl;
  final Map<String, dynamic> productDetails;
  final bool isProcessed;

  UploadSessionItem({
    this.id,
    required this.barcode,
    this.imageUrl,
    this.productDetails = const {},
    this.isProcessed = false,
  });

  factory UploadSessionItem.fromJson(Map<String, dynamic> json) {
    return UploadSessionItem(
      id: json['id'],
      barcode: json['barcode'],
      imageUrl: json['image'], // Server returns full URL usually? Or path.
      productDetails: json['product_details'] ?? {},
      isProcessed: json['is_processed'] ?? false,
    );
  }
}

class ProductUploadSession {
  final int id;
  final String? name;
  final String status;
  final DateTime createdAt;
  final List<UploadSessionItem> items;

  ProductUploadSession({
    required this.id,
    this.name,
    required this.status,
    required this.createdAt,
    this.items = const [],
  });

  factory ProductUploadSession.fromJson(Map<String, dynamic> json) {
    var itemsList = <UploadSessionItem>[];
    if (json['items'] != null) {
      itemsList = (json['items'] as List)
          .map((i) => UploadSessionItem.fromJson(i))
          .toList();
    }

    return ProductUploadSession(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      items: itemsList,
    );
  }
}
