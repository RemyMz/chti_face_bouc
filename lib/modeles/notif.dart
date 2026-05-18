import 'package:cloud_firestore/cloud_firestore.dart';
import 'constantes.dart';

class Notif {
  DocumentReference reference;
  String id;
  Map<String, dynamic> map;

  Notif({required this.reference, required this.id, required this.map});

  String get from => map[fromKey] ?? "";
  String get text => map[textKey] ?? "";
  String get postID => map[postIdKey] ?? "";
  bool get read => map[isReadKey] ?? false;
  int get date => map[dateKey] ?? 0;
}
