import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services_firebase/service_firestore.dart';

/// Bouton permettant de déclencher la sélection d'une image (profil ou couverture).
class BoutonCamera extends StatelessWidget {
  /// Type d'image à mettre à jour (ex: profilePictureKey ou coverPictureKey).
  final String type;
  
  /// Identifiant unique du membre concerné.
  final String id;

  const BoutonCamera({super.key, required this.type, required this.id});

  /// Gère l'acquisition de l'image via la galerie et lance la mise à jour sur Firebase.
  void _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? xfile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 500);
    
    if (xfile != null) {
      if (kIsWeb) {
        // Traitement spécifique pour le Web
        final bytes = await xfile.readAsBytes();
        ServiceFirestore().updateImage(
          webBytes: bytes,
          folder: "members",
          memberId: id,
          imageName: type
        );
      } else {
        // Traitement pour Mobile
        File file = File(xfile.path);
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
