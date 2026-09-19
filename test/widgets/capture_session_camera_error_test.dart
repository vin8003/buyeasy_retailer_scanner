import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:buyeasy_retailer_scanner/providers/auth_provider.dart';
import 'package:buyeasy_retailer_scanner/providers/scanner_provider.dart';
import 'package:buyeasy_retailer_scanner/screens/capture_session_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows a retryable camera error instead of spinning forever', (
    tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ScannerProvider()),
        ],
        child: MaterialApp(
          home: CaptureSessionScreen(discoverCameras: () async => []),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('No camera found on this device.'), findsOneWidget);
    expect(find.text('Retry camera'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('SAVE & NEXT stays disabled when the barcode is blank', (
    tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ScannerProvider()),
        ],
        child: MaterialApp(
          home: CaptureSessionScreen(discoverCameras: () async => []),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Enter Manually'));
    await tester.pump();

    final saveButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'SAVE & NEXT'),
    );
    expect(saveButton.onPressed, isNull);
  });
}
