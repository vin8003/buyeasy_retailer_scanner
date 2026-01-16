import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/scanner_provider.dart';
import '../providers/auth_provider.dart';

class CaptureSessionScreen extends StatefulWidget {
  static const routeName = '/capture-session';

  const CaptureSessionScreen({super.key});

  @override
  State<CaptureSessionScreen> createState() => _CaptureSessionScreenState();
}

class _CaptureSessionScreenState extends State<CaptureSessionScreen>
    with WidgetsBindingObserver {
  final MobileScannerController _scannerController = MobileScannerController();
  final ImagePicker _picker = ImagePicker();

  bool _isScanning = true;
  String? _scannedBarcode;
  File? _capturedImage;
  bool _isUploading = false;

  // Form Controllers
  final _nameController = TextEditingController();
  final _mrpController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Auto-fill Selling Price from MRP if Price is empty
    _mrpController.addListener(() {
      if (_priceController.text.isEmpty) {
        // We don't force update to avoid fighting user,
        // but we can set it when MRP changes if Price is blank.
        // Or strictly on submit? The prompt said: "If ... leaves ... empty, automatically set ... by default"
        // Let's do it on submit to keep UI simple/stable.
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_scannerController.value.isInitialized) return;
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _scannerController.start();
      case AppLifecycleState.inactive:
        _scannerController.stop();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _nameController.dispose();
    _mrpController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  void _onBarcodeDetect(BarcodeCapture capture) {
    if (!_isScanning || _isUploading) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      setState(() {
        _scannedBarcode = barcodes.first.rawValue;
        _isScanning = false; // Stop scanning, move to photo
      });
      // Optionally pause scanner to save battery/cpu
      _scannerController.stop();
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 800, // Optimize size: Resize strictly
        maxHeight: 800,
        imageQuality: 85, // Good quality, low size
      );

      if (photo != null) {
        setState(() {
          _capturedImage = File(photo.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error taking photo: $e')));
    }
  }

  void _resetFlow() {
    setState(() {
      _scannedBarcode = null;
      _capturedImage = null;
      _isScanning = true;
      _scannerController.start();

      // Clear Form
      _nameController.clear();
      _mrpController.clear();
      _priceController.clear();
      _qtyController.clear();
    });
  }

  void _addCurrentItemToQueue() {
    if (_scannedBarcode == null || _capturedImage == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final scannerProvider = Provider.of<ScannerProvider>(
      context,
      listen: false,
    );

    // Instant UI update
    try {
      // Parse Details
      String? name = _nameController.text.trim();
      if (name.isEmpty) name = null;

      double? mrp = double.tryParse(_mrpController.text.trim());
      double? price = double.tryParse(_priceController.text.trim());
      int? qty = int.tryParse(_qtyController.text.trim());

      // Auto-Fill Price Logic: If MRP exists but Price is missing, Price = MRP
      if (mrp != null && price == null) {
        price = mrp;
      }

      scannerProvider.addItemToQueue(
        authProvider.token!,
        _scannedBarcode!,
        _capturedImage!,
        name: name,
        price: price,
        mrp: mrp,
        quantity: qty,
      );

      // Removed blocking SnackBar for speed.
      // Instant reset is key for "Rapid Scan".
      _resetFlow();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Queue Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scannerProvider = Provider.of<ScannerProvider>(context);
    final session = scannerProvider.currentSession;
    final pendingCount = scannerProvider.pendingCount;

    // If no session active, show error or auto-start?
    // Usually Gateway should have started it.
    if (session == null && !scannerProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Session Error')),
        body: Center(child: Text("No active session")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan & Snap (${session?.items.length ?? 0})',
              style: const TextStyle(fontSize: 16),
            ),
            if (pendingCount > 0)
              Text(
                'Syncing $pendingCount items...',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Finish Session
              if (pendingCount > 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please wait for uploads to finish'),
                  ),
                );
                return;
              }
              Navigator.of(context).pop(); // Go back to Gateway
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Step 1: Scanner View
          if (_isScanning)
            Expanded(
              flex: 2,
              child: MobileScanner(
                controller: _scannerController,
                onDetect: _onBarcodeDetect,
                fit: BoxFit.cover,
              ),
            ),

          // Step 2: Photo & Confirm View
          if (!_isScanning)
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Barcode: $_scannedBarcode",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Product Details Form
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name (Optional)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _mrpController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'MRP',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Selling Price',
                              hintText: 'Same as MRP',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stock Qty',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),

                    const SizedBox(height: 20),
                    if (_capturedImage == null)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt, size: 40),
                        label: const Text("Take Photo"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: _takePhoto,
                      )
                    else ...[
                      Image.file(_capturedImage!, height: 200),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: _resetFlow,
                            child: const Text("Retake"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                            ),
                            onPressed: _addCurrentItemToQueue,
                            child: const Text("Submit & Next"),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // Instructions / Footer
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _isScanning
                        ? "Point camera at barcode"
                        : (_capturedImage == null
                              ? "Take a photo of the product front"
                              : "Tap 'Submit & Next' to continue instantly"),
                  ),
                ),
                if (!_isScanning)
                  TextButton(
                    onPressed: _resetFlow,
                    child: const Text("Cancel"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
