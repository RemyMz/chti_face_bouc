import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services_firebase/service_firestore.dart';

class BoutonCamera extends StatelessWidget {
  final String type; // profilePictureKey ou coverPictureKey
  final String id;   // UID du membre

  const BoutonCamera({super.key, required this.type, required this.id});

  // Méthode _takePicture demandée à l'étape 6.6
  void _takePicture() async {
    final ImagePicker picker = ImagePicker();
    // Acquisition de l'image à partir de la galerie (Etape 6.6)
    final XFile? xfile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 500);
    
    if (xfile != null) {
      if (kIsWeb) {
        final bytes = await xfile.readAsBytes();
        ServiceFirestore().updateImage(
          webBytes: bytes,
          folder: "members",
          memberId: id,
          imageName: type
        );
      } else {
        File file = File(xfile.path);
        // Appel du service pour stockage et mise à jour
        ServiceFirestore().updateImage(
          file: file, 
          folder: "members", 
          memberId: id, 
          imageName: type
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _takePicture, 
      icon: const Icon(Icons.camera_alt)
    );
  }
}
