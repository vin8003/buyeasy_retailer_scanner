class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String unit;
  final String? image;
  final String? imageUrl;
  final String? categoryName;
  final String? brandName;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.unit,
    this.image,
    this.imageUrl,
    this.categoryName,
    this.brandName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      description: _asString(json['description']),
      price: _asDouble(json['price']),
      quantity: _asInt(json['quantity']),
      unit: _asString(json['unit'], fallback: 'piece'),
      image: _asNullableString(json['image']),
      imageUrl: _asNullableString(json['image_url']),
      categoryName: _asNullableString(json['category_name']),
      brandName: _asNullableString(json['brand_name']),
    );
  }

  static int _asInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ??
        double.tryParse(value.toString())?.toInt() ??
        0;
  }

  static double _asDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString();
    return text.isEmpty ? fallback : text;
  }

  static String? _asNullableString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
}
