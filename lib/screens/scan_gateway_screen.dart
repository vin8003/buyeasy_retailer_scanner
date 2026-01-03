import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/scanner_provider.dart';
import 'capture_session_screen.dart';
// import 'product_lookup_screen.dart'; // To be implemented

import '../utils/url_config_dialog.dart';

class ScanGatewayScreen extends StatelessWidget {
  const ScanGatewayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Retailer Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showServerUrlDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, ${user?.shopName ?? "Retailer"}!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Visual Bulk Upload Button
            Consumer<ScannerProvider>(
              builder: (context, scannerProvider, _) {
                if (scannerProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton.icon(
                  onPressed: () async {
                    final auth = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    try {
                      await scannerProvider.startSession(auth.token!);
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CaptureSessionScreen(),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  },
                  icon: const Icon(Icons.add_a_photo, size: 32),
                  label: const Text('Start Bulk Upload Session'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(24),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Link to Retailer App Info
            const Text(
              "Note: Review and processing happens in the main Retailer App.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
