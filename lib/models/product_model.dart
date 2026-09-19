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
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: _asDouble(json['price']),
      quantity: _asInt(json['quantity']),
      unit: json['unit']?.toString() ?? 'piece',
      image: json['image']?.toString(),
      imageUrl: json['image_url']?.toString(),
      categoryName: json['category_name']?.toString(),
      brandName: json['brand_name']?.toString(),
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
