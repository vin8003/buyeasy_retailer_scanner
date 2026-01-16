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
  bool _isLoading = false;
  String? _error;

  // Queue System
  final List<QueueItem> _pendingQueue = [];
  final List<QueueItem> _failedQueue = [];
  bool _isProcessingQueue = false;

  ProductUploadSession? get currentSession => _currentSession;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<QueueItem> get pendingQueue => UnmodifiableListView(_pendingQueue);
  List<QueueItem> get failedQueue => UnmodifiableListView(_failedQueue);
  int get pendingCount => _pendingQueue.length;

  // Start a new session
  Future<void> startSession(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentSession = await _productService.createUploadSession(token);
      print("Session Started: ${_currentSession?.id}");
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
        print("Restoring Session: $sessionId");
        _currentSession = await _productService.getSessionDetails(
          token,
          sessionId,
        );
        return true;
      }
    } catch (e) {
      print("Failed to restore session: $e");
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

  // Add item to queue (Instant Return)
  void addItemToQueue(
    String token,
    String barcode,
    File image, {
    String? name,
    double? price,
    double? mrp,
    int? quantity,
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
            },
          );

          // Success
          _currentSession!.items.insert(0, newItem);
          _pendingQueue.remove(item);
          print("Uploaded Item: ${item.barcode}");
        } catch (e) {
          print("Upload Failed for ${item.barcode}: $e");
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
