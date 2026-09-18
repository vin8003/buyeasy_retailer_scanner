import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_logger.dart';

class OCRService {
  final _textRecognizer = TextRecognizer();
  final _picker = ImagePicker();

  Future<String?> scanTextFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return null;

      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      return recognizedText.text;
    } catch (e, st) {
      AppLogger.error(
        'OCR text recognition failed',
        error: e,
        stackTrace: st,
        tag: 'OCRService',
      );
      return null;
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
