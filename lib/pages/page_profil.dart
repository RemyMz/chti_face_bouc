import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeles/membre.dart';
import '../modeles/constantes.dart';
import '../modeles/post.dart';
import '../services_firebase/service_firestore.dart';
import '../services_firebase/service_authentification.dart';
import '../widgets/avatar.dart';
import '../widgets/bouton_camera.dart';
import '../widgets/widget_post.dart';
import 'page_modifier_profil.dart';

/// Page de profil d'un membre.
/// Permet de voir les informations, les images (couverture/profil) et les publications du membre.
class PageProfil extends StatefulWidget {
  /// Le membre dont on affiche le profil.
  final Membre member;
  const PageProfil({super.key, required this.member});

  @override
  State<PageProfil> createState() => _PageProfilState();
}

class _PageProfilState extends State<PageProfil> {
  @override
  Widget build(BuildContext context) {
    // Vérifie si le profil affiché est celui de l'utilisateur connecté
    bool isMe = ServiceAuthentification().isMe(widget.member.id);

    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(widget.member.id),
      builder: (context, memberSnapshot) {
        if (!memberSnapshot.hasData || memberSnapshot.data?.data() == null) return const Center(child: CircularProgressIndicator());
        
        final data = memberSnapshot.data!;
        final Membre member = Membre(
          reference: data.reference, 
          id: data.id, 
          map: data.data() as Map<String, dynamic>
        );

        return StreamBuilder<QuerySnapshot>(
          // Récupère uniquement les publications de ce membre
          stream: ServiceFirestore().postForMember(member.id),
          builder: (context, postSnapshot) {
            if (postSnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Erreur : ${postSnapshot.error.toString()}", 
                        style: const TextStyle(color: Colors.red)),
                ),
              );
            }
            
            final docs = postSnapshot.data?.docs ?? [];
            
            return Scaffold(
              body: ListView.builder(
                itemCount: docs.length + 1, // +1 pour l'en-tête (profil)
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Section en-tête : Couverture, Avatar, Infos
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            // Image de couverture
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                image: member.coverPicture.isNotEmpty 
                                  ? DecorationImage(image: NetworkImage(member.coverPicture), fit: BoxFit.cover) 
                                  : null,
                              ),
                              child: isMe ? Container(
                                alignment: Alignment.bottomRight,
                                child: BoutonCamera(type: coverPictureKey, id: member.id),
                              ) : null,
                            ),
                            // Photo de profil décalée
                            Transform.translate(
                              offset: const Offset(0, 50),
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Avatar(radius: 60, url: member.profilePicture),
                                  if (isMe) BoutonCamera(type: profilePictureKey, id: member.id),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        Text(member.fullName, style: Theme.of(context).textTheme.headlineMedium),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(member.description.isEmpty ? "Pas encore de description..." : member.description),
                        ),
                        // Bouton d'édition visible uniquement sur son propre profil
                        if (isMe) OutlinedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => PageModifierProfil(member: member)
                            ));
                          }, 
                          child: const Text("Modifier le profil")
                        ),
                        const SizedBox(height: 20),
                        const Divider(thickness: 2),
                      ],
                    );
                  } else {
                    // Liste des publications du membre
                    final postDoc = docs[index - 1];
                    final Post post = Post(
                      reference: postDoc.reference,
                      id: postDoc.id,
                      map: postDoc.data() as Map<String, dynamic>
                    );
                    return WidgetPost(post: post);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
