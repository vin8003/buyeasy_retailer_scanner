import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/product_model.dart';

class ProductService {
  Future<List<Product>> getProducts(String token) async {
    final response = await http.get(
      Uri.parse(ApiConstants.products),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded is Map ? decoded['results'] : decoded;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> addProduct(
    String token,
    Map<String, dynamic> productData,
  ) async {
    final response = await http.post(
      Uri.parse(ApiConstants.createProduct),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(productData),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to add product');
    }
  }

  Future<Product> updateProduct(
    String token,
    int productId,
    Map<String, dynamic> productData,
  ) async {
    final response = await http.patch(
      Uri.parse(ApiConstants.updateProduct(productId)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(productData),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to update product');
    }
  }

  Future<List<Map<String, dynamic>>> getCategories(String token) async {
    final response = await http.get(
      Uri.parse(ApiConstants.categories),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Map<String, dynamic>>> getBrands(String token) async {
    final response = await http.get(
      Uri.parse(ApiConstants.brands),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load brands');
    }
  }

  Future<Map<String, dynamic>> searchMasterProduct(
    String token,
    String barcode,
  ) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.masterProductSearch}?barcode=$barcode'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Product not found in master catalog');
    } else {
      throw Exception('Failed to search product');
    }
  }
}
