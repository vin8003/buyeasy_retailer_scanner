import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ocr_service.dart';
import '../providers/product_provider.dart';
import '../providers/auth_provider.dart';

class OCRProductFormScreen extends StatefulWidget {
  const OCRProductFormScreen({super.key});

  @override
  State<OCRProductFormScreen> createState() => _OCRProductFormScreenState();
}

class _OCRProductFormScreenState extends State<OCRProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ocrService = OCRService();

  // Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _ocrService.dispose();
    super.dispose();
  }

  Future<void> _scanText(TextEditingController controller) async {
    final text = await _ocrService.scanTextFromCamera();
    if (text != null) {
      // In a real app, you might want to show a dialog to let user select specific text
      // For now, we just append or set
      setState(() {
        controller.text = text;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    if (auth.token == null) return;

    setState(() => _isLoading = true);

    final productData = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': double.tryParse(_priceController.text) ?? 0,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'unit': 'piece', // Default
      'is_active': true,
    };

    try {
      await context.read<ProductProvider>().addProduct(
        auth.token!,
        productData,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Product Added!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product with OCR')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildOCRField(
                controller: _nameController,
                label: 'Product Name',
                icon: Icons.tag,
              ),
              const SizedBox(height: 16),
              _buildOCRField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildOCRField(
                // Price usually simpler to type, but consistency
                controller: _priceController,
                label: 'Price',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildOCRField(
                controller: _quantityController,
                label: 'Quantity',
                icon: Icons.inventory,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('SAVE PRODUCT'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOCRField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: icon != null ? Icon(icon) : null,
              border: const OutlineInputBorder(),
            ),
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: () => _scanText(controller),
          icon: const Icon(Icons.camera_alt),
          tooltip: 'Scan Text',
        ),
      ],
    );
  }
}
