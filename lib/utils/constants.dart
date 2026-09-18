import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'api_base_url.dart';

class ApiConstants {
  static String _serverUrl = _originFromEnv();

  static String get serverUrl => _serverUrl;
  static String get baseUrl => ApiBaseUrl.toApiRoot(_serverUrl);

  static String _originFromEnv() {
    final fromEnv = dotenv.env['API_BASE_URL'];
    if (fromEnv == null || fromEnv.trim().isEmpty) {
      return ApiBaseUrl.defaultOrigin;
    }
    try {
      return ApiBaseUrl.normalizeOrigin(fromEnv);
    } catch (_) {
      return ApiBaseUrl.defaultOrigin;
    }
  }

  static Future<void> loadServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('api_server_url');
    if (url == null || url.isEmpty) return;
    try {
      _serverUrl = ApiBaseUrl.normalizeOrigin(url);
    } catch (_) {
      _serverUrl = ApiBaseUrl.defaultOrigin;
    }
  }

  static Future<void> setServerUrl(String url) async {
    _serverUrl = ApiBaseUrl.normalizeOrigin(url);
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
