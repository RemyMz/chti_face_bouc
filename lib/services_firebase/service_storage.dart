import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

/// Service gérant le stockage des fichiers (images) sur Firebase Storage.
class ServiceStorage {
  /// Instance unique de Firebase Storage.
  static final instance = FirebaseStorage.instance;
  
  /// Référence racine du stockage.
  Reference get ref => instance.ref();

  /// Télécharge une image à partir d'un fichier local.
  /// [file] : Le fichier à uploader.
  /// [folder] : Le dossier de destination.
  /// [memberId] : L'identifiant du membre.
  /// [imageName] : Le nom du fichier sur le serveur.
  Future<String> addImage({required File file, required String folder, required String memberId, required String imageName}) async {
    Reference reference = ref.child(folder).child(memberId).child(imageName);
    UploadTask task = reference.putFile(file);
    TaskSnapshot snapshot = await task.whenComplete(() => null);
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  /// Télécharge une image à partir d'octets (Uint8List), utile pour le support Web.
  /// [bytes] : Les données binaires de l'image.
  /// [folder] : Le dossier de destination.
  /// [memberId] : L'identifiant du membre.
  /// [imageName] : Le nom du fichier sur le serveur.
  Future<String> addImageWeb({required Uint8List bytes, required String folder, required String memberId, required String imageName}) async {
    Reference reference = ref.child(folder).child(memberId).child(imageName);
    UploadTask task = reference.putData(bytes);
    TaskSnapshot snapshot = await task.whenComplete(() => null);
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
