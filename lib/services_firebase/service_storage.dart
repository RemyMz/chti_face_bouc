import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class ServiceStorage {
  static final instance = FirebaseStorage.instance;
  Reference get ref => instance.ref();

  Future<String> addImage({required File file, required String folder, required String memberId, required String imageName}) async {
    Reference reference = ref.child(folder).child(memberId).child(imageName);
    UploadTask task = reference.putFile(file);
    TaskSnapshot snapshot = await task.whenComplete(() => null);
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  // Support Web (Uint8List)
  Future<String> addImageWeb({required Uint8List bytes, required String folder, required String memberId, required String imageName}) async {
    Reference reference = ref.child(folder).child(memberId).child(imageName);
    UploadTask task = reference.putData(bytes);
    TaskSnapshot snapshot = await task.whenComplete(() => null);
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
