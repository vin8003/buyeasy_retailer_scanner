import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buyeasy_retailer_scanner/widgets/camera_error_panel.dart';

void main() {
  testWidgets('shows the camera error and invokes retry', (tester) async {
    var retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CameraErrorPanel(
            message: 'Camera permission denied',
            onRetry: () => retried = true,
          ),
        ),
      ),
    );

    expect(find.text('Camera permission denied'), findsOneWidget);
    expect(find.text('Retry camera'), findsOneWidget);

    await tester.tap(find.text('Retry camera'));
    await tester.pump();

    expect(retried, isTrue);
  });
}
