import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/scanner_provider.dart';
import 'screens/login_screen.dart';
import 'screens/scan_gateway_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/app_logger.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.error(
      'Flutter framework error',
      error: details.exception,
      stackTrace: details.stack,
      tag: 'FlutterError',
    );
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    AppLogger.error(
      'Uncaught async/platform error',
      error: error,
      stackTrace: stack,
      tag: 'PlatformDispatcher',
    );
    // Return false so the error still propagates (logging only; do not swallow).
    return false;
  };

  try {
    await dotenv.load(fileName: ".env");
    await ApiConstants.loadServerUrl();
  } catch (e, st) {
    AppLogger.error(
      'Startup configuration failed',
      error: e,
      stackTrace: st,
      tag: 'main',
    );
    rethrow;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
      ],
      child: MaterialApp(
        title: 'Retailer Scanner',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) {
          return const ScanGatewayScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
