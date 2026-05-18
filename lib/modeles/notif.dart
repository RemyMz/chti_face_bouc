import 'package:cloud_firestore/cloud_firestore.dart';
import 'constantes.dart';

/// Modèle représentant une notification pour l'utilisateur.
class Notif {
  /// Référence du document Firestore.
  DocumentReference reference;
  
  /// Identifiant unique de la notification.
  String id;
  
  /// Map contenant les données brutes de la notification.
  Map<String, dynamic> map;

  Notif({required this.reference, required this.id, required this.map});

  /// Identifiant du membre à l'origine de la notification.
  String get from => map[fromKey] ?? "";
  
  /// Texte de la notification.
  String get text => map[textKey] ?? "";
  
  /// Identifiant du post concerné par la notification.
  String get postID => map[postIdKey] ?? "";
  
  /// Indique si la notification a été lue.
  bool get read => map[isReadKey] ?? false;
  
  /// Date de création de la notification.
  int get date => map[dateKey] ?? 0;
}
