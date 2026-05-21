import 'package:cloud_firestore/cloud_firestore.dart';
import 'constantes.dart';

/// Représente un message individuel au sein d'une discussion.
class Message {
  final DocumentReference reference;
  final String id;
  late String senderId;
  late String text;
  late int timestamp;
  late bool isRead;

  Message({required this.reference, required this.id, required Map<String, dynamic> map}) {
    senderId = map[senderIdKey] ?? "";
    text = map[textKey] ?? "";
    timestamp = map[dateKey] ?? 0;
    isRead = map[isMessageReadKey] ?? false;
  }
}
