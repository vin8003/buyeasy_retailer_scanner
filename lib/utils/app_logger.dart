import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Lightweight crash/error logger for diagnosing scanner failures (KAN-18).
///
/// Logs to both [developer.log] (structured, filterable) and [debugPrint]
/// (visible in `flutter run` / logcat). Does not change control flow.
class AppLogger {
  static const String name = 'RetailerScanner';

  /// Logs an error on an existing failure path or uncaught crash handler.
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    final prefix = tag == null ? '' : '[$tag] ';
    developer.log(
      '$prefix$message',
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: 1000, // SEVERE
    );

    final detail = error == null ? '' : ': $error';
    debugPrint('ERROR $prefix$message$detail');
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
