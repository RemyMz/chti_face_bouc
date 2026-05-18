import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/membre.dart';
import '../widgets/avatar.dart';
import '../widgets/widget_vide.dart';
import 'page_profil.dart';

class PageMembres extends StatefulWidget {
  const PageMembres({super.key});

  @override
  State<PageMembres> createState() => _PageMembresState();
}

class _PageMembresState extends State<PageMembres> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Les membres"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ServiceFirestore().allMembers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            if (docs.isEmpty) return const EmptyBody();

            return ListView.separated(
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
                  onTap: () {
                    // Etape 7.3 : Renvoyer sur sa page de profil
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
