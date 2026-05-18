import 'package:cloud_firestore/cloud_firestore.dart';
import 'constantes.dart';

/// Modèle représentant un utilisateur (membre) de l'application.
/// Encapsule les données provenant de Firestore pour un accès typé et sécurisé.
class Membre {
  /// Référence directe vers le document dans Firestore.
  DocumentReference reference;
  
  /// Identifiant unique de l'utilisateur (UID Firebase Auth).
  String id;
  
  /// Map contenant les données brutes du document.
  Map<String, dynamic> map;

  Membre({required this.reference, required this.id, required this.map});

  /// Nom de famille.
  String get name => map[nameKey] ?? "";
  
  /// Prénom.
  String get surname => map[surnameKey] ?? "";
  
  /// URL de l'image de profil.
  String get profilePicture => map[profilePictureKey] ?? "";
  
  /// URL de l'image de couverture (Header).
  String get coverPicture => map[coverPictureKey] ?? "";
  
  /// Biographie ou description de l'utilisateur.
  String get description => map[descriptionKey] ?? "";
  
  /// Retourne le nom complet formaté (Prénom Nom).
  String get fullName => "$surname $name";
}
