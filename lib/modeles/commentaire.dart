import 'package:cloud_firestore/cloud_firestore.dart';
import 'constantes.dart';

/// Modèle représentant un commentaire sur une publication.
class Commentaire {
  /// Référence du document Firestore.
  DocumentReference reference;
  
  /// Identifiant unique du commentaire.
  String id;
  
  /// Map contenant les données brutes du commentaire.
  Map<String, dynamic> map;

  Commentaire({required this.reference, required this.id, required this.map});

  /// Identifiant du membre ayant écrit le commentaire.
  String get member => map[memberIdKey] ?? "";
  
  /// Contenu textuel du commentaire.
  String get text => map[textKey] ?? "";
  
  /// Date de création au format timestamp.
  int get date => map[dateKey] ?? 0;
}
