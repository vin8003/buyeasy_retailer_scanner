import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Dummy/local origin for Android emulator. Never a live host.
const String kDummyLocalServerUrl = 'http://10.0.2.2:8000';

/// Picks a dummy/local default when [candidate] is empty or a live host.
String resolveServerUrl(String? candidate) {
  final url = candidate?.trim() ?? '';
  if (url.isEmpty) {
    return kDummyLocalServerUrl;
  }
  final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';
  if (host.isEmpty ||
      host == 'ordereasy.win' ||
      host.endsWith('.ordereasy.win')) {
    return kDummyLocalServerUrl;
  }
  return url;
}

class ApiConstants {
  static String _serverUrl = kDummyLocalServerUrl;

  static String get serverUrl => _serverUrl;
  static String get baseUrl => '$serverUrl/api';

  static Future<void> loadServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('api_server_url');
    _serverUrl = resolveServerUrl(
      (saved != null && saved.isNotEmpty) ? saved : dotenv.env['API_BASE_URL'],
    );
  }

  static Future<void> setServerUrl(String url) async {
    _serverUrl = resolveServerUrl(url);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_server_url', _serverUrl);
  }

  // Auth endpoints
  static String get login => '$baseUrl/auth/retailer/login/';
  static String get signup => '$baseUrl/auth/retailer/signup/';
  static String get profile => '$baseUrl/auth/profile/';
  static String get verifyOtp => '$baseUrl/auth/customer/verify-otp/';

  // Product endpoints
  static String get products => '$baseUrl/products/';
  static String get createProduct => '$baseUrl/products/create/';
  static String get categories => '$baseUrl/products/categories/';
  static String get brands => '$baseUrl/products/brands/';
  static String productDetail(int id) => '$baseUrl/products/$id/';
  static String updateProduct(int id) => '$baseUrl/products/$id/update/';
  static String deleteProduct(int id) => '$baseUrl/products/$id/delete/';
  static String get masterProductSearch => '$baseUrl/products/master/search/';

  // Visual Bulk Upload
  static String get createUploadSession =>
      '$baseUrl/products/upload/session/create/';
  static String get addSessionItem =>
      '$baseUrl/products/upload/session/add-item/';
  static String sessionDetails(int id) =>
      '$baseUrl/products/upload/session/details/$id/';
  static String get activeSessions =>
      '$baseUrl/products/upload/session/active/';
}
