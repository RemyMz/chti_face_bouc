import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_firestore.dart';
import '../services_firebase/service_authentification.dart';
import '../modeles/membre.dart';
import '../widgets/avatar.dart';
import '../widgets/widget_vide.dart';
import 'page_profil.dart';
import 'page_chat.dart';

/// Page affichant la liste de tous les membres inscrits sur l'application.
class PageMembres extends StatefulWidget {
  const PageMembres({super.key});

  @override
  State<PageMembres> createState() => _PageMembresState();
}

class _PageMembresState extends State<PageMembres> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        // Écoute en temps réel de tous les utilisateurs inscrits
        stream: ServiceFirestore().allMembers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            if (docs.isEmpty) return const EmptyBody();

            return ListView.separated(
              padding: const EdgeInsets.only(top: 100, bottom: 100),
              itemCount: docs.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final Membre member = Membre(
                  reference: docs[index].reference, 
                  id: docs[index].id, 
                  map: data
                );

                return ListTile(
                  leading: Avatar(radius: 20, url: member.profilePicture),
                  title: Text(member.fullName),
                  subtitle: Text(member.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: () async {
                      final myId = ServiceAuthentification().myId;
                      if (myId != null && myId != member.id) {
                        final chatId = await ServiceFirestore().createOrGetChatRoom(myId, member.id);
                        if (context.mounted) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => PageChat(chatId: chatId, otherMember: member)
                          ));
                        }
                      }
                    },
                  ),
                  onTap: () {
                    // Navigation vers la page de profil du membre sélectionné
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PageProfil(member: member)
                    ));
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
