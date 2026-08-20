import 'package:buyeasy_retailer_scanner/utils/app_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppLogger.error completes without throwing', () {
    expect(
      () => AppLogger.error(
        'unit-test error',
        error: Exception('boom'),
        stackTrace: StackTrace.current,
        tag: 'AppLoggerTest',
      ),
      returnsNormally,
    );
  });
}
