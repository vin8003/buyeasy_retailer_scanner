import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String serverUrl =
      dotenv.env['API_BASE_URL'] ??
      'http://10.0.2.2:8000'; // Default to Android emulator localhost
  static String baseUrl = '$serverUrl/api';

  // Auth endpoints
  static String login = '$baseUrl/auth/retailer/login/';
  static String signup = '$baseUrl/auth/retailer/signup/';
  static String profile = '$baseUrl/auth/profile/';
  static String verifyOtp = '$baseUrl/auth/customer/verify-otp/';

  // Product endpoints
  static String products = '$baseUrl/products/';
  static String createProduct = '$baseUrl/products/create/';
  static String categories = '$baseUrl/products/categories/';
  static String brands = '$baseUrl/products/brands/';
  static String productDetail(int id) => '$baseUrl/products/$id/';
  static String updateProduct(int id) => '$baseUrl/products/$id/update/';
  static String deleteProduct(int id) => '$baseUrl/products/$id/delete/';
  static String masterProductSearch = '$baseUrl/products/master/search/';
}
