import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'session_selection_screen.dart';
// import 'product_lookup_screen.dart'; // To be implemented

import '../utils/url_config_dialog.dart';

class ScanGatewayScreen extends StatefulWidget {
  const ScanGatewayScreen({super.key});

  @override
  State<ScanGatewayScreen> createState() => _ScanGatewayScreenState();
}

class _ScanGatewayScreenState extends State<ScanGatewayScreen> {
  @override
  void initState() {
    super.initState();
    // Removed auto-resume to allow user choice
  }

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
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SessionSelectionScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.photo_library, size: 32),
              label: const Text('Manage Upload Sessions'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(24),
                textStyle: const TextStyle(fontSize: 18),
              ),
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
