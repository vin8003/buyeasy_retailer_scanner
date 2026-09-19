import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('.env does not hard-code a live *.ordereasy.win base URL', () {
    final envFile = File('.env');
    expect(
      envFile.existsSync(),
      isTrue,
      reason: '.env should ship as a local dummy',
    );

    final contents = envFile.readAsStringSync();
    expect(contents.toLowerCase(), isNot(contains('ordereasy.win')));
    expect(contents, contains('API_BASE_URL='));
  });
}
