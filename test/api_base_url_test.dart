import 'dart:io';

import 'package:buyeasy_retailer_scanner/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('empty or missing config resolves to dummy local emulator URL', () {
    expect(resolveServerUrl(null), kDummyLocalServerUrl);
    expect(resolveServerUrl(''), kDummyLocalServerUrl);
    expect(resolveServerUrl('   '), kDummyLocalServerUrl);
    expect(kDummyLocalServerUrl, 'http://10.0.2.2:8000');
  });

  test('live production hosts fall back to dummy local default', () {
    expect(
      resolveServerUrl('https://api.ordereasy.win/api/'),
      kDummyLocalServerUrl,
    );
    expect(resolveServerUrl('https://ordereasy.win'), kDummyLocalServerUrl);
    expect(
      resolveServerUrl('https://staging.ordereasy.win'),
      kDummyLocalServerUrl,
    );
  });

  test('explicit local dummy origins are kept', () {
    expect(resolveServerUrl('http://127.0.0.1:8000'), 'http://127.0.0.1:8000');
    expect(resolveServerUrl('http://localhost:9000'), 'http://localhost:9000');
    expect(resolveServerUrl(kDummyLocalServerUrl), kDummyLocalServerUrl);
  });

  test('committed .env does not hardcode a live production host', () {
    final env = File('.env').readAsStringSync();
    expect(env.contains('ordereasy.win'), isFalse);
    expect(env.contains('API_BASE_URL=$kDummyLocalServerUrl'), isTrue);
  });

  test('loadServerUrl and setServerUrl sanitize a saved live host', () async {
    SharedPreferences.setMockInitialValues({
      'api_server_url': 'https://api.ordereasy.win/api/',
    });
    await ApiConstants.loadServerUrl();
    expect(ApiConstants.serverUrl, kDummyLocalServerUrl);

    await ApiConstants.setServerUrl('https://staging.ordereasy.win');
    expect(ApiConstants.serverUrl, kDummyLocalServerUrl);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('api_server_url'), kDummyLocalServerUrl);
  });
}
