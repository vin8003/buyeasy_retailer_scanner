import 'dart:io';
import 'package:flutter/material.dart';
import '../models/upload_session_model.dart';
import '../services/product_service.dart';

class ScannerProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  ProductUploadSession? _currentSession;
  bool _isLoading = false;
  String? _error;

  ProductUploadSession? get currentSession => _currentSession;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Start a new session
  Future<void> startSession(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentSession = await _productService.createUploadSession(token);
      print("Session Started: ${_currentSession?.id}");
    } catch (e) {
      _error = e.toString();
      _currentSession = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add item to current session
  Future<void> addItem(String token, String barcode, File image) async {
    if (_currentSession == null) {
      throw Exception("No active session");
    }

    _isLoading = true;
    _error = null; // Clear previous errors
    notifyListeners();

    try {
      final newItem = await _productService.addSessionItem(
        token,
        _currentSession!.id,
        barcode,
        image,
      );

      // Update local list to show recent scans
      // Note: addSessionItem API returns the Created Item.
      // We might want to prepend it to the list for UI visibility.
      _currentSession!.items.insert(0, newItem);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSession() {
    _currentSession = null;
    _error = null;
    notifyListeners();
  }
}
