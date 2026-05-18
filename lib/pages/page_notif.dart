import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/notif.dart';
import '../widgets/widget_notif.dart';
import '../widgets/widget_vide.dart';
import '../modeles/membre.dart';

/// Page affichant les notifications reçues par l'utilisateur (likes, commentaires, etc.).
class PageNotif extends StatelessWidget {
  /// Le membre pour lequel on affiche les notifications.
  final Membre member;
  const PageNotif({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes notifications"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Récupère les notifications filtrées pour l'utilisateur actuel
        stream: ServiceFirestore().notificationForUser(member.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const EmptyBody();
          }
          final docs = snapshot.data!.docs;
          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              // Conversion en objet Notif pour un affichage typé
              final Notif notification = Notif(
                reference: docs[index].reference, 
                id: docs[index].id, 
                map: docs[index].data() as Map<String, dynamic>
              );
              return WidgetNotif(notification: notification);
            },
          );
        },
      ),
    );
  }
}
