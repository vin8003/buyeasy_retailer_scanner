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
      id: _asNullableInt(json['id']),
      barcode: json['barcode']?.toString() ?? '',
      imageUrl: json['image']?.toString(),
      productDetails: _asStringKeyedMap(json['product_details']),
      isProcessed: json['is_processed'] == true,
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
    List<UploadSessionItem>? items,
  }) : items = items ?? [];

  factory ProductUploadSession.fromJson(Map<String, dynamic> json) {
    final items = <UploadSessionItem>[];
    final rawItems = json['items'];
    if (rawItems is List) {
      for (final row in rawItems) {
        if (row is Map) {
          items.add(UploadSessionItem.fromJson(Map<String, dynamic>.from(row)));
        }
      }
    }

    return ProductUploadSession(
      id: _asInt(json['id']),
      name: json['name']?.toString(),
      status: json['status']?.toString() ?? 'unknown',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      items: items,
    );
  }

  factory ProductUploadSession.fromDetailsResponse(dynamic decoded) {
    if (decoded is! Map) {
      throw const FormatException('Invalid session response');
    }
    final session = decoded['session'];
    if (session == null) {
      throw const FormatException('Missing session object');
    }
    if (session is! Map) {
      throw const FormatException('Invalid session object');
    }
    return ProductUploadSession.fromJson(Map<String, dynamic>.from(session));
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

Map<String, dynamic> _asStringKeyedMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}
