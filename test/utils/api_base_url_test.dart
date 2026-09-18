import 'package:flutter_test/flutter_test.dart';
import 'package:buyeasy_retailer_scanner/utils/api_base_url.dart';

void main() {
  group('ApiBaseUrl.normalizeOrigin', () {
    test('keeps local emulator origin and strips trailing slash', () {
      expect(
        ApiBaseUrl.normalizeOrigin('http://10.0.2.2:8000/'),
        'http://10.0.2.2:8000',
      );
    });

    test('strips a trailing /api so callers do not double the prefix', () {
      expect(
        ApiBaseUrl.normalizeOrigin('http://10.0.2.2:9000/api/'),
        'http://10.0.2.2:9000',
      );
    });

    test('rejects empty input', () {
      expect(
        () => ApiBaseUrl.normalizeOrigin('   '),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects live *.ordereasy.win hosts', () {
      expect(
        () => ApiBaseUrl.normalizeOrigin('https://api.ordereasy.win/api/'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => ApiBaseUrl.normalizeOrigin('https://retailer.ordereasy.win'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('ApiBaseUrl.toApiRoot', () {
    test('appends /api once', () {
      expect(
        ApiBaseUrl.toApiRoot('http://10.0.2.2:8000'),
        'http://10.0.2.2:8000/api',
      );
    });

    test('does not double /api if origin already ends with it', () {
      expect(
        ApiBaseUrl.toApiRoot('http://10.0.2.2:8000/api'),
        'http://10.0.2.2:8000/api',
      );
    });
  });

  group('ApiBaseUrl.isForbiddenHost', () {
    test('flags only ordereasy.win hosts', () {
      expect(ApiBaseUrl.isForbiddenHost('https://api.ordereasy.win'), isTrue);
      expect(ApiBaseUrl.isForbiddenHost('http://10.0.2.2:8000'), isFalse);
      expect(ApiBaseUrl.isForbiddenHost('http://10.0.2.2:9000'), isFalse);
    });
  });
}
