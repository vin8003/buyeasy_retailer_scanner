import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:flutter/foundation.dart';
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
  CameraController? _cameraController;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  // State Management
  bool _isCameraInitialized = false;
  bool _isProcessingFrame = false; // Throttle frame processing
  bool _isEditing = false; // "Form Mode" vs "Scan Mode"
  bool _isLookingUp = false;
  File? _capturedImage;
  String? _lookupInfoText;

  // Form Controllers
  final _barcodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _mrpController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();

  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();

    // Auto-fill Selling Price from MRP
    _mrpController.addListener(() {
      // Logic if needed
    });
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('No camera found')));
        }
        return;
      }

      // Pick first rear camera
      final camera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high, // Good for both preview and photo
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();
      if (!mounted) return;

      // Start Image Stream for Scanning
      await _cameraController!.startImageStream(_processCameraImage);

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Camera Error: $e')));
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-initialize camera on resume if needed (usually handled by plugin, but good practice to check)
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // _cameraController?.dispose();
      // We might not want to fully dispose if we want fast resume, but standard practice is to dispose to release resource.
      // However, for this specific "Stay Open" requirement, we just let it be handled or pause stream?
      // CameraController usually needs to be re-initialized after resume.
    } else if (state == AppLifecycleState.resumed) {
      if (_cameraController != null) {
        // onResume logic
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _barcodeScanner.close();

    _barcodeController.dispose();
    _nameController.dispose();
    _mrpController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  // --- Scanning Logic ---

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessingFrame || _isEditing || !_isCameraInitialized) return;
    _isProcessingFrame = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
        // Found barcode!
        final code = barcodes.first.rawValue!;
        // Pause stream processing effectively by setting _isEditing (or stop stream explicitly?)
        // To keep camera preview running, we DON'T stop stream, just ignore frames in valid state.
        if (mounted) {
          _startEditing(code);
        }
      }
    } catch (e) {
      print("Scan Error: $e");
    } finally {
      if (mounted) {
        // Add small delay to prevent CPU burn if no barcode found?
        // await Future.delayed(const Duration(milliseconds: 100)); // Optional throttle
        _isProcessingFrame = false;
      }
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;

    // TODO: Handle rotation properly based on device orientation
    // For now assuming standard portrait mode

    final InputImageRotation rotation =
        InputImageRotationValue.fromRawValue(sensorOrientation) ??
        InputImageRotation.rotation0deg;

    // Valid format checks
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      // On iOS usually bgra8888. On Android nv21.
      // return null;
      // Note: CameraController with ImageFormatGroup usually handles this but let's be safe.
    }

    // Since we can't easily convert planes to bytes manually without heavy boilerplate,
    // we use the helper logic often found in ML Kit examples.
    // For simplicity in this generated code, we assume standard NV21/BGRA.

    // For simplicity in this generated code, we assume standard NV21/BGRA.

    return InputImage.fromBytes(
      bytes: _concatenatePlanes(image.planes),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used to be rotation, now specific enum
        format: format ?? InputImageFormat.nv21, // fallback
        bytesPerRow: image.planes[0].bytesPerRow, // Main plane
      ),
    );
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  // --- Actions ---

  void _startEditing(String? barcode) {
    setState(() {
      _isEditing = true;
      _barcodeController.text = barcode ?? '';
      _nameController.clear();
      _mrpController.clear();
      _priceController.clear();
      _qtyController.clear();
      _capturedImage = null;
      _isLookingUp = false;
      _lookupInfoText = null;
    });

    if (barcode != null && barcode.isNotEmpty) {
      _performLookup(barcode);
    }
  }

  Future<void> _performLookup(String barcode) async {
    setState(() {
      _isLookingUp = true;
      _lookupInfoText = "Searching...";
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final scannerProvider = Provider.of<ScannerProvider>(
        context,
        listen: false,
      );

      final data = await scannerProvider.lookupProduct(
        authProvider.token!,
        barcode,
      );

      if (mounted) {
        setState(() {
          _isLookingUp = false;
          if (data != null) {
            print("Product Found: $data");
            _lookupInfoText = "Found in Master Catalog";
            _nameController.text = data['name'] ?? '';
            _mrpController.text = (data['mrp'] ?? '').toString();
            // Price is often same as MRP initially
            _priceController.text = (data['mrp'] ?? '').toString();
          } else {
            _lookupInfoText = "New Product (Not found)";
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLookingUp = false;
          _lookupInfoText = "Lookup error";
        });
      }
    }
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _capturedImage = null;
    });
    // Stream continues running but now _isEditing is false, so it will pick up frames again.
  }

  Future<void> _takePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;
    if (_cameraController!.value.isTakingPicture) return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = File(photo.path);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Capture Error: $e')));
      }
    }
  }

  Future<void> _submitItem() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final scannerProvider = Provider.of<ScannerProvider>(
      context,
      listen: false,
    );

    // Validate
    final barcode = _barcodeController.text.trim();
    if (barcode.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Barcode is required')));
      return;
    }

    if (_capturedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please take a photo')));
      return;
    }

    try {
      String? name = _nameController.text.trim();
      if (name.isEmpty) name = null;

      double? mrp = double.tryParse(_mrpController.text.trim());
      double? price = double.tryParse(_priceController.text.trim());
      int? qty = int.tryParse(_qtyController.text.trim());

      if (mrp != null && price == null) {
        price = mrp;
      }

      scannerProvider.addItemToQueue(
        authProvider.token!,
        barcode,
        _capturedImage!,
        name: name,
        price: price,
        mrp: mrp,
        quantity: qty,
      );

      _cancelEditing(); // Reset immediately
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

    final size = MediaQuery.of(context).size;
    final double halfHeight = size.height * 0.5;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Keep transparent to float over camera if needed, or black for distinct look?
        // User requested "Top Half -> Live Camera Preview". AppBar usually floats or sits above.
        // I will make it semi-transparent black to ensure visibility over camera.
        backgroundColor: Colors.black45,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session: ${session?.name ?? "Unititled"}',
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
            icon:
                _cameraController != null &&
                    _cameraController!.value.isInitialized
                ? ValueListenableBuilder(
                    valueListenable: _cameraController!,
                    builder: (context, value, child) {
                      return Icon(
                        value.flashMode == FlashMode.torch
                            ? Icons.flash_on
                            : Icons.flash_off,
                        color: value.flashMode == FlashMode.torch
                            ? Colors.yellow
                            : Colors.grey,
                      );
                    },
                  )
                : const Icon(Icons.flash_off, color: Colors.grey),
            onPressed: () async {
              if (_cameraController != null &&
                  _cameraController!.value.isInitialized) {
                final newMode =
                    _cameraController!.value.flashMode == FlashMode.torch
                    ? FlashMode.off
                    : FlashMode.torch;
                await _cameraController!.setFlashMode(newMode);
                setState(() {}); // refresh icon
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () {
              if (pendingCount > 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please wait for uploads to finish'),
                  ),
                );
                return;
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      // Use a Column for the split layout
      body: Column(
        children: [
          // 1. Top Half: Camera Preview (Square)
          SizedBox(
            height: halfHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: Colors.black), // Background for padding
                if (_isCameraInitialized && _cameraController != null)
                  Center(
                    // Enforce 1:1 Square
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRect(
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: size.width,
                              // Calculate height based on aspect ratio to ensure full coverage
                              // Usually camera aspect ratio is 4/3 or 16/9.
                              // We just need it to be big enough to cover the square.
                              height:
                                  size.width *
                                  (_cameraController!.value.aspectRatio < 1
                                      ? 1 / _cameraController!.value.aspectRatio
                                      : _cameraController!.value.aspectRatio),
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),

          // 2. Bottom Half: Form or Scan Prompt
          Expanded(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: _buildBottomPanel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    // Shared text styles
    // Logic: If not editing, show "Ready to Scan". If editing, show Form.

    if (!_isEditing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "Point camera at barcode",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.keyboard),
              label: const Text("Enter Manually"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              onPressed: () => _startEditing(null),
            ),
          ],
        ),
      );
    }

    // Form
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Product Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (_isLookingUp)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _cancelEditing,
              ),
            ],
          ),
          if (_lookupInfoText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _lookupInfoText!,
                style: TextStyle(
                  color: _lookupInfoText!.contains("Found")
                      ? Colors.green
                      : Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const Divider(),

          TextField(
            controller: _barcodeController,
            decoration: const InputDecoration(
              labelText: 'Barcode',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.qr_code),
              isDense: true,
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Product Name',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            textInputAction: TextInputAction.next,
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
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'Same as MRP',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _qtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Qty',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _capturedImage == null
                    ? ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Capture"),
                        onPressed: _takePhoto,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.deepPurple.shade50,
                          foregroundColor: Colors.deepPurple,
                        ),
                      )
                    : OutlinedButton.icon(
                        icon: const Icon(Icons.check, color: Colors.green),
                        label: const Text("Retake"),
                        onPressed: _takePhoto,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
              ),
            ],
          ),

          if (_capturedImage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_capturedImage!, fit: BoxFit.cover),
                ),
              ),
            ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitItem,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text("SAVE & NEXT"),
          ),
          // Add padding for keyboard if needed, mostly handled by Scaffold resize but good to have safety
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
          ),
        ],
      ),
    );
  }
}
