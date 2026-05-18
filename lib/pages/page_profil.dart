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

class PageProfil extends StatefulWidget {
  final Membre member;
  const PageProfil({super.key, required this.member});

  @override
  State<PageProfil> createState() => _PageProfilState();
}

class _PageProfilState extends State<PageProfil> {
  @override
  Widget build(BuildContext context) {
    bool isMe = ServiceAuthentification().isMe(widget.member.id);

    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(widget.member.id),
      builder: (context, memberSnapshot) {
        if (!memberSnapshot.hasData || memberSnapshot.data?.data() == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        final data = memberSnapshot.data!;
        final Membre member = Membre(
          reference: data.reference, 
          id: data.id, 
          map: data.data() as Map<String, dynamic>
        );

        return StreamBuilder<QuerySnapshot>(
          stream: ServiceFirestore().postForMember(member.id),
          builder: (context, postSnapshot) {
            final docs = postSnapshot.data?.docs ?? [];
            
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  // SliverAppBar avec effet Parallaxe
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    stretch: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(member.fullName, 
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 10, color: Colors.black45)]
                        )
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (member.coverPicture.isNotEmpty)
                            Image.network(member.coverPicture, fit: BoxFit.cover)
                          else
                            Container(color: Theme.of(context).colorScheme.primary),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black54],
                              ),
                            ),
                          ),
                          if (isMe) Positioned(
                            top: 50,
                            right: 10,
                            child: BoutonCamera(type: coverPictureKey, id: member.id),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Header Infos Profil
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -50),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Avatar(radius: 60, url: member.profilePicture),
                              if (isMe) BoutonCamera(type: profilePictureKey, id: member.id),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                member.description.isEmpty ? "Pas encore de description..." : member.description,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 16),
                              if (isMe) OutlinedButton.icon(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => PageModifierProfil(member: member)
                                )), 
                                icon: const Icon(Icons.edit_rounded),
                                label: const Text("Modifier le profil"),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(indent: 50, endIndent: 50),
                        ),
                      ],
                    ),
                  ),

                  // Liste des publications
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final postDoc = docs[index];
                        final Post post = Post(
                          reference: postDoc.reference,
                          id: postDoc.id,
                          map: postDoc.data() as Map<String, dynamic>
                        );
                        return WidgetPost(post: post);
                      },
                      childCount: docs.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
