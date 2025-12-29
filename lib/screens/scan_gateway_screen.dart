import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'ocr_product_form_screen.dart';
// import 'product_lookup_screen.dart'; // To be implemented

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

            // Barcode Search Button
            ElevatedButton.icon(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => const ProductLookupScreen()),
                // );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Barcode Lookup coming soon")),
                );
              },
              icon: const Icon(Icons.qr_code_scanner, size: 32),
              label: const Text('Lookup Product (Barcode)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(24),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 24),

            // OCR Add Product Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OCRProductFormScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.document_scanner, size: 32),
              label: const Text('Add Product (OCR)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(24),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
