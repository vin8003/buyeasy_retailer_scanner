import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/upload_session_model.dart';
import '../models/queue_item_model.dart';
import '../services/product_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ScannerProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  ProductUploadSession? _currentSession;
  List<ProductUploadSession> _sessions = [];
  bool _isLoading = false;
  String? _error;

  // Queue System
  final List<QueueItem> _pendingQueue = [];
  final List<QueueItem> _failedQueue = [];
  bool _isProcessingQueue = false;

  ProductUploadSession? get currentSession => _currentSession;
  List<ProductUploadSession> get sessions => UnmodifiableListView(_sessions);
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<QueueItem> get pendingQueue => UnmodifiableListView(_pendingQueue);
  List<QueueItem> get failedQueue => UnmodifiableListView(_failedQueue);
  int get pendingCount => _pendingQueue.length;

  // Fetch active sessions
  Future<void> fetchActiveSessions(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sessions = await _productService.getActiveSessions(token);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Start a new session
  Future<void> startSession(String token, {String? name}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentSession = await _productService.createUploadSession(
        token,
        name: name,
      );

      await _saveSessionId(_currentSession!.id);
    } catch (e) {
      _error = e.toString();
      _currentSession = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Restore session from persistence
  Future<bool> restoreSession(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getInt('active_upload_session_id');

      if (sessionId != null) {
        // We need to fetch details. getSessionDetails gets a single session details.
        // But ideally we should also fetch list of active sessions if we are going to fallback to list?
        // For now, if ID exists, try to restore it.
        _currentSession = await _productService.getSessionDetails(
          token,
          sessionId,
        );
        return true;
      }
    } catch (e) {
      // If restore fails (e.g. 404), clear it
      await _clearSessionId();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> _saveSessionId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('active_upload_session_id', id);
  }

  Future<void> _clearSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('active_upload_session_id');
  }

  // Resume a specific session
  Future<void> resumeSession(String token, int sessionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentSession = await _productService.getSessionDetails(
        token,
        sessionId,
      );
      await _saveSessionId(sessionId);
    } catch (e) {
      _error = "Failed to resume: $e";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lookup Product details
  Future<Map<String, dynamic>?> lookupProduct(
    String token,
    String barcode,
  ) async {
    try {
      final data = await _productService.searchMasterProduct(token, barcode);
      return data;
    } catch (e) {
      return null;
    }
  }

  // Add item to queue (Instant Return)
  void addItemToQueue(
    String token,
    String barcode,
    File image, {
    String? name,
    double? price,
    double? mrp,
    int? quantity,
    String? productGroup,
  }) {
    if (_currentSession == null) {
      throw Exception("No active session");
    }

    final item = QueueItem(
      barcode: barcode,
      image: image,
      name: name,
      price: price,
      mrp: mrp,
      quantity: quantity,
      productGroup: productGroup,
    );
    _pendingQueue.add(item);
    notifyListeners();

    // Trigger processing
    _processQueue(token);
  }

  // Process Queue Logic
  Future<void> _processQueue(String token) async {
    if (_isProcessingQueue) return;
    if (_pendingQueue.isEmpty) return;

    _isProcessingQueue = true;
    // notifyListeners(); // Not needed usually unless we show "Syncing..." status

    try {
      while (_pendingQueue.isNotEmpty) {
        final item = _pendingQueue.first;
        item.isUploading = true;
        notifyListeners(); // Update status of item

        try {
          final newItem = await _productService.addSessionItem(
            token,
            _currentSession!.id,
            item.barcode,
            item.image,
            details: {
              'name': item.name,
              'price': item.price,
              'mrp': item.mrp,
              'quantity': item.quantity,
              'product_group': item.productGroup,
            },
          );

          // Success
          _currentSession!.items.insert(0, newItem);
          _pendingQueue.remove(item);
        } catch (e) {
          item.isUploading = false;
          item.isFailed = true;
          _pendingQueue.remove(item);
          _failedQueue.add(item);
        } finally {
          notifyListeners();
        }
      }
    } finally {
      _isProcessingQueue = false;
      notifyListeners();
    }
  }

  void retryFailedItem(String token, QueueItem item) {
    if (_failedQueue.contains(item)) {
      _failedQueue.remove(item);
      item.isFailed = false;
      _pendingQueue.add(item);
      notifyListeners();
      _processQueue(token);
    }
  }

  void clearSession() {
    _currentSession = null;
    _error = null;
    _pendingQueue.clear();
    _failedQueue.clear();
    _clearSessionId(); // Remove from storage
    notifyListeners();
  }
}
