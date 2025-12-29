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
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: double.parse(json['price'].toString()),
      quantity: json['quantity'] ?? 0,
      unit: json['unit'] ?? 'piece',
      image: json['image'],
      imageUrl: json['image_url'],
      categoryName: json['category_name'],
      brandName: json['brand_name'],
    );
  }
}
