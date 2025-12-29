import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _brands = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get brands => _brands;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMetadata(String token) async {
    try {
      final results = await Future.wait([
        _productService.getCategories(token),
        _productService.getBrands(token),
      ]);
      _categories = results[0];
      _brands = results[1];
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching metadata: $e');
    }
  }

  Future<Map<String, dynamic>> searchMasterProduct(
    String token,
    String barcode,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _productService.searchMasterProduct(token, barcode);
      return result;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(
    String token,
    Map<String, dynamic> productData,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final newProduct = await _productService.addProduct(token, productData);
      _products.insert(0, newProduct);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
