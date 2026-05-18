import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../modeles/constantes.dart';
import '../modeles/membre.dart';
import '../modeles/post.dart';
import 'service_storage.dart';
import 'service_authentification.dart';

class ServiceFirestore {
  // Accès à la BDD Firestore spécifique 'defo'
  static final instance = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'defo'
  );

  // Accès spécifique collection
  final firestoreMember = instance.collection(memberCollectionKey);
  final firestorePost = instance.collection(postCollectionKey);

  // Ajouter un membre
  addMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).set(data);
  }

  // Mettre à jour un membre
  updateMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).update(data);
  }

  // Permet de lire les informations d'un membre spécifique en temps réel
  Stream<DocumentSnapshot> specificMember(String id) {
    return firestoreMember.doc(id).snapshots();
  }

  // Lire la liste de tous les membres
  Stream<QuerySnapshot> allMembers() {
    return firestoreMember.snapshots();
  }

  // Lire la liste de tous les posts triés par date (du plus récent au plus ancien)
  Stream<QuerySnapshot> allPosts() {
    return firestorePost.orderBy(dateKey, descending: true).snapshots();
  }

  // Lire les posts d'un utilisateur (Etape 9.4)
  Stream<QuerySnapshot> postForMember(String id) {
    return firestorePost.where(memberIdKey, isEqualTo: id).orderBy(dateKey, descending: true).snapshots();
  }

  // Créer un post (Etape 8.1)
  Future<void> createPost(Membre member, String text, File? image, Uint8List? webImage) async {
    Map<String, dynamic> data = {
      memberIdKey: member.id,
      textKey: text,
      dateKey: DateTime.now().millisecondsSinceEpoch,
      likesKey: [],
    };
    
    DocumentReference ref = await firestorePost.add(data);
    
    if (kIsWeb && webImage != null) {
      String url = await ServiceStorage().addImageWeb(
        bytes: webImage, 
        folder: "posts", 
        memberId: member.id, 
        imageName: ref.id
      );
      await ref.update({postImageKey: url});
    } else if (image != null) {
      String url = await ServiceStorage().addImage(
        file: image, 
        folder: "posts", 
        memberId: member.id, 
        imageName: ref.id
      );
      await ref.update({postImageKey: url});
    }
  }

  // Ajouter un like sur le post (Etape 10.1)
  addLike({required String memberID, required Post post}) {
    if (post.likes.contains(memberID)) {
      post.reference.update({likesKey: FieldValue.arrayRemove([memberID])});
    } else {
      post.reference.update({likesKey: FieldValue.arrayUnion([memberID])});
      // Notification pour le Like
      sendNotification(to: post.memberId, text: "a aimé votre post", postID: post.id);
    }
  }

  // Ajouter un commentaire (Etape 11.2)
  addComment({required Post post, required String text}) {
    final memberId = ServiceAuthentification().myId;
    if (memberId == null) return;
    Map<String, dynamic> map = {
      memberIdKey: memberId,
      dateKey: DateTime.now().millisecondsSinceEpoch,
      textKey: text,
    };
    post.reference.collection(commentCollectionKey).add(map);
    // Notification pour le commentaire
    sendNotification(to: post.memberId, text: "a commenté votre post", postID: post.id);
  }

  // Lire les commentaires d'un post (Etape 11.2)
  Stream<QuerySnapshot> postComment({required String postId}) {
    return firestorePost.doc(postId).collection(commentCollectionKey).orderBy(dateKey, descending: true).snapshots();
  }

  // Etape 12.2 : Envoyer une notification
  sendNotification({required String to, required String text, required String postID}) {
    final from = ServiceAuthentification().myId;
    if (from == null || from == to) return;
    Map<String, dynamic> data = {
      fromKey: from,
      textKey: text,
      postIdKey: postID,
      isReadKey: false,
      dateKey: DateTime.now().millisecondsSinceEpoch,
    };
    instance.collection(memberCollectionKey).doc(to).collection(notificationCollectionKey).add(data);
  }

  // Etape 12.2 : Marquer une notification comme lue
  markRead(DocumentReference reference) {
    reference.update({isReadKey: true});
  }

  // Etape 12.2 : Lire les notifications d'un utilisateur
  Stream<QuerySnapshot> notificationForUser(String id) {
    return firestoreMember.doc(id).collection(notificationCollectionKey).orderBy(dateKey, descending: true).snapshots();
  }

  // Stockage et mise à jour d'une image
  updateImage({
    File? file,
    Uint8List? webBytes,
    required String folder,
    required String memberId,
    required String imageName
  }) async {
    String? imageUrl;
    if (kIsWeb && webBytes != null) {
      imageUrl = await ServiceStorage().addImageWeb(
        bytes: webBytes, 
        folder: folder, 
        memberId: memberId, 
        imageName: imageName
      );
    } else if (file != null) {
      imageUrl = await ServiceStorage().addImage(
        file: file, 
        folder: folder, 
        memberId: memberId, 
        imageName: imageName
      );
    }
    
    if (imageUrl != null) {
      updateMember(id: memberId, data: {imageName: imageUrl});
    }
  }
}
