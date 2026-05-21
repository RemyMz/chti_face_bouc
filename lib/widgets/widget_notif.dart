import 'package:flutter/material.dart';
import '../modeles/notif.dart';
import '../services_firebase/service_firestore.dart';
import 'formatage_date.dart';
import '../widgets/avatar.dart';
import '../modeles/membre.dart';
import '../modeles/post.dart';
import '../pages/page_detail_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Widget représentant un élément de notification dans la liste des notifications.
class WidgetNotif extends StatelessWidget {
  /// La notification à afficher.
  final Notif notification;
  const WidgetNotif({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      // Récupère les informations de l'expéditeur de la notification
      stream: ServiceFirestore().specificMember(notification.from),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) return const SizedBox();
        
        final data = snapshot.data!;
        final Membre member = Membre(
          reference: data.reference, 
          id: data.id, 
          map: data.data() as Map<String, dynamic>
        );

        return Container(
          // Met en évidence les notifications non lues par une couleur de fond
          color: notification.read ? Colors.transparent : Colors.brown.shade50,
          child: ListTile(
            onTap: () async {
              // Marque la notification comme lue lors du clic
              ServiceFirestore().markRead(notification.reference);
              // Récupère le post associé et navigue vers son détail
              final Post? post = await ServiceFirestore().getSpecificPost(notification.postID);
              if (post != null && context.mounted) {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => PageDetailPost(post: post))
                );
              }
            },
            leading: Avatar(radius: 20, url: member.profilePicture),
            title: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(text: member.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: " ${notification.text}"),
                ]
              ),
            ),
            subtitle: Text(
              FormatageDate().formatted(notification.date),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            trailing: notification.read 
              ? const Icon(Icons.check_circle_outline, color: Colors.grey, size: 16)
              : const Icon(Icons.circle, color: Colors.brown, size: 10),
          ),
        );
      }
    );
  }
}
