import 'package:cloud_firestore/cloud_firestore.dart';
import 'constantes.dart';

/// Représente une salle de discussion (chat) entre deux membres.
class Chat {
  final DocumentReference reference;
  final String id;
  late List<String> users;
  late String lastMessage;
  late int lastUpdate;

  Chat({required this.reference, required this.id, required Map<String, dynamic> map}) {
    users = List<String>.from(map[usersKey] ?? []);
    lastMessage = map[lastMessageKey] ?? "";
    lastUpdate = map[lastUpdateKey] ?? 0;
  }

  /// Récupère l'ID de l'autre membre de la discussion.
  String getOtherUserId(String myId) {
    return users.firstWhere((id) => id != myId, orElse: () => "");
  }
}
