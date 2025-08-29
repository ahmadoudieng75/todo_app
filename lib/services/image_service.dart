import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la sélection de l\'image: $e');
    }
  }

  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la capture de l\'image: $e');
    }
  }

  Future<String> saveImagePermanently(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = '${directory.path}/$fileName';

      final File savedImage = await imageFile.copy(path);
      return savedImage.path;
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde de l\'image: $e');
    }
  }
}