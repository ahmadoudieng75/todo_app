import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/services/image_service.dart';
import 'dart:io';


class ProfileAvatar extends StatefulWidget {
  final String? imagePath;
  final Function(String) onImageSelected;

  const ProfileAvatar({
    super.key,
    this.imagePath,
    required this.onImageSelected,
  });

  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  final ImageService _imageService = ImageService();

  Future<void> _pickImage(ImageSource source) async {
    try {
      File? imageFile;

      if (source == ImageSource.gallery) {
        imageFile = await _imageService.pickImageFromGallery();
      } else {
        imageFile = await _imageService.pickImageFromCamera();
      }

      if (imageFile != null) {
        final String savedPath = await _imageService.saveImagePermanently(imageFile);
        widget.onImageSelected(savedPath);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Changer la photo de profil'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Galerie'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Appareil photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImagePickerDialog,
      child: CircleAvatar(
        radius: 30,
        backgroundImage: widget.imagePath != null
            ? FileImage(File(widget.imagePath!)) as ImageProvider
            : AssetImage('assets/images/default_avatar.png'),
        child: widget.imagePath == null
            ? Icon(Icons.person, size: 30)
            : null,
      ),
    );
  }
}