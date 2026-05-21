import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../modeles/constantes.dart';
import '../modeles/membre.dart';
import '../modeles/post.dart';
import 'service_storage.dart';
import 'service_authentification.dart';

/// Service gérant toutes les interactions avec la base de données Cloud Firestore.
/// Centralise les opérations CRUD pour les membres, les posts, les commentaires et les notifications.
class ServiceFirestore {
  // Singleton pattern for better performance
  static final ServiceFirestore _instance = ServiceFirestore._internal();
  factory ServiceFirestore() => _instance;
  ServiceFirestore._internal();

  /// Instance spécifique de Firestore (ID 'defo').
  static final firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'defo'
  );

  /// Références aux collections principales
  final firestoreMember = firestore.collection(memberCollectionKey);
  final firestorePost = firestore.collection(postCollectionKey);

  /// Ajoute un nouveau membre à la collection lors de l'inscription.
  Future<void> addMember({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await firestoreMember.doc(id).set(data);
  }

  /// Met à jour les informations d'un membre existant.
  Future<void> updateMember({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await firestoreMember.doc(id).update(data);
  }

  /// Fournit un flux de données (Stream) pour un membre spécifique via son ID.
  Stream<DocumentSnapshot> specificMember(String id) {
    return firestoreMember.doc(id).snapshots();
  }

  /// Fournit un flux de données pour la liste exhaustive de tous les membres.
  Stream<QuerySnapshot> allMembers() {
    return firestoreMember.snapshots();
  }

  /// Récupère tous les posts de l'application, triés par date décroissante.
  Stream<QuerySnapshot> allPosts() {
    return firestorePost.orderBy(dateKey, descending: true).snapshots();
  }

  /// Récupère les posts spécifiques d'un utilisateur donné.
  Stream<QuerySnapshot> postForMember(String id) {
    return firestorePost
        .where(memberIdKey, isEqualTo: id)
        .orderBy(dateKey, descending: true)
        .snapshots();
  }

  /// Crée un nouveau post avec texte et potentiellement une image.
  /// Gère la différence entre les plateformes Web (Uint8List) et Mobile (File).
  Future<void> createPost(
    Membre member,
    String text,
    File? image,
    Uint8List? webImage,
  ) async {
    Map<String, dynamic> data = {
      memberIdKey: member.id,
      textKey: text,
      dateKey: DateTime.now().millisecondsSinceEpoch,
      likesKey: [],
    };

    // Ajout initial du post pour obtenir une référence (ID de document)
    DocumentReference ref = await firestorePost.add(data);

    // Traitement de l'image si elle est présente
    if (kIsWeb && webImage != null) {
      String url = await ServiceStorage().addImageWeb(
        bytes: webImage,
        folder: "posts",
        memberId: member.id,
        imageName: ref.id,
      );
      await ref.update({postImageKey: url});
    } else if (image != null) {
      String url = await ServiceStorage().addImage(
        file: image,
        folder: "posts",
        memberId: member.id,
        imageName: ref.id,
      );
      await ref.update({postImageKey: url});
    }
  }

  /// Gère l'ajout ou le retrait d'un "Like" sur un post.
  /// Envoie également une notification au créateur du post.
  addLike({required String memberID, required Post post}) {
    if (post.likes.contains(memberID)) {
      // Si déjà aimé, on retire le like
      post.reference.update({
        likesKey: FieldValue.arrayRemove([memberID]),
      });
    } else {
      // Sinon, on ajoute le like
      post.reference.update({
        likesKey: FieldValue.arrayUnion([memberID]),
      });
      // Déclenchement d'une notification
      sendNotification(
        to: post.memberId,
        text: "a aimé votre post",
        postID: post.id,
      );
    }
  }

  /// Ajoute un commentaire à un post spécifique.
  addComment({required Post post, required String text}) {
    final memberId = ServiceAuthentification().myId;
    if (memberId == null) return;

    Map<String, dynamic> map = {
      memberIdKey: memberId,
      dateKey: DateTime.now().millisecondsSinceEpoch,
      textKey: text,
    };

    // Les commentaires sont stockés dans une sous-collection du document Post
    post.reference.collection(commentCollectionKey).add(map);

    // Notification pour le créateur du post
    sendNotification(
      to: post.memberId,
      text: "a commenté votre post",
      postID: post.id,
    );
  }

  /// Récupère le flux de commentaires pour un post donné.
  Stream<QuerySnapshot> postComment({required String postId}) {
    return firestorePost
        .doc(postId)
        .collection(commentCollectionKey)
        .orderBy(dateKey, descending: true)
        .snapshots();
  }

  /// Récupère un post spécifique par son ID.
  Future<Post?> getSpecificPost(String postId) async {
    final doc = await firestorePost.doc(postId).get();
    if (doc.exists) {
      return Post(
        reference: doc.reference,
        id: doc.id,
        map: doc.data() as Map<String, dynamic>,
      );
    }
    return null;
  }

  /// Crée une notification pour un utilisateur spécifique.
  /// Empêche l'envoi d'une notification à soi-même.
  sendNotification({
    required String to,
    required String text,
    required String postID,
  }) {
    final from = ServiceAuthentification().myId;
    if (from == null || from == to) return;

    Map<String, dynamic> data = {
      fromKey: from,
      textKey: text,
      postIdKey: postID,
      isReadKey: false,
      dateKey: DateTime.now().millisecondsSinceEpoch,
    };

    // Notifications stockées dans une sous-collection de l'utilisateur destinataire
    firestoreMember
        .doc(to)
        .collection(notificationCollectionKey)
        .add(data);
  }

  /// Récupère les données d'un membre spécifique (Future).
  Future<Membre?> getMember(String id) async {
    final doc = await firestoreMember.doc(id).get();
    if (doc.exists) {
      return Membre(reference: doc.reference, id: doc.id, map: doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Marque une notification spécifique comme consultée.
  markRead(DocumentReference reference) {
    reference.update({isReadKey: true});
  }

  /// Récupère le flux de notifications pour un utilisateur.
  Stream<QuerySnapshot> notificationForUser(String id) {
    return firestoreMember
        .doc(id)
        .collection(notificationCollectionKey)
        .orderBy(dateKey, descending: true)
        .snapshots();
  }

  /// Gère l'upload et la mise à jour des images de profil ou de couverture.
  updateImage({
    File? file,
    Uint8List? webBytes,
    required String folder,
    required String memberId,
    required String imageName,
  }) async {
    String? imageUrl;

    // Upload vers Firebase Storage
    if (kIsWeb && webBytes != null) {
      imageUrl = await ServiceStorage().addImageWeb(
        bytes: webBytes,
        folder: folder,
        memberId: memberId,
        imageName: imageName,
      );
    } else if (file != null) {
      imageUrl = await ServiceStorage().addImage(
        file: file,
        folder: folder,
        memberId: memberId,
        imageName: imageName,
      );
    }

    // Mise à jour de l'URL dans le profil Firestore du membre
    if (imageUrl != null) {
      updateMember(id: memberId, data: {imageName: imageUrl});
    }
  }
}
