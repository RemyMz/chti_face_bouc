import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_firestore.dart';
import '../services_firebase/service_authentification.dart';
import '../modeles/chat.dart';
import '../modeles/membre.dart';
import '../widgets/avatar.dart';
import '../widgets/widget_vide.dart';
import '../widgets/formatage_date.dart';
import 'page_chat.dart';

class PageConversations extends StatelessWidget {
  const PageConversations({super.key});

  @override
  Widget build(BuildContext context) {
    final myId = ServiceAuthentification().myId;
    if (myId == null) return const Scaffold(body: Center(child: Text("Connectez-vous pour voir vos messages")));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Discussions"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ServiceFirestore().streamChatsForUser(myId),
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
              final Chat chat = Chat(
                reference: docs[index].reference,
                id: docs[index].id,
                map: docs[index].data() as Map<String, dynamic>
              );
              
              final otherUserId = chat.getOtherUserId(myId);

              // Récupérer les infos de l'autre membre
              return StreamBuilder<DocumentSnapshot>(
                stream: ServiceFirestore().specificMember(otherUserId),
                builder: (context, memberSnapshot) {
                  if (!memberSnapshot.hasData) return const SizedBox.shrink();
                  
                  final Membre otherMember = Membre(
                    reference: memberSnapshot.data!.reference,
                    id: memberSnapshot.data!.id,
                    map: memberSnapshot.data!.data() as Map<String, dynamic>
                  );

                  return ListTile(
                    leading: Avatar(url: otherMember.profilePicture, radius: 25),
                    title: Text(otherMember.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      chat.lastMessage, 
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      FormatageDate().formatted(chat.lastUpdate),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => PageChat(chatId: chat.id, otherMember: otherMember))
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
