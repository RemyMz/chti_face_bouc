import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/notif.dart';
import '../widgets/widget_notif.dart';
import '../widgets/widget_vide.dart';
import '../modeles/membre.dart';

class PageNotif extends StatelessWidget {
  final Membre member;
  const PageNotif({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes notifications"),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
