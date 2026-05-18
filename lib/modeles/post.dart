import 'package:cloud_firestore/cloud_firestore.dart';
import 'constantes.dart';

/// Modèle représentant une publication (post) sur le réseau social.
class Post {
  /// Référence du document Firestore.
  DocumentReference reference;
  
  /// Identifiant unique de la publication.
  String id;
  
  /// Map contenant les données brutes de la publication.
  Map<String, dynamic> map;

  Post({required this.reference, required this.id, required this.map});

  /// Identifiant du membre ayant créé la publication.
  String get memberId => map[memberIdKey] ?? "";
  
  /// Contenu textuel de la publication.
  String get text => map[textKey] ?? "";
  
  /// URL de l'image associée à la publication, si elle existe.
  String get imageUrl => map[postImageKey] ?? "";
  
  /// Date de création au format timestamp (millisecondes).
  int get date => map[dateKey] ?? 0;
  
  /// Liste des identifiants des membres ayant aimé la publication.
  List<dynamic> get likes => map[likesKey] ?? [];
}
