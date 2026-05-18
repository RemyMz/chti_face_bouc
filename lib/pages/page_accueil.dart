import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/post.dart';
import '../widgets/widget_post.dart';
import '../widgets/widget_vide.dart';

// Etape 5.2 : Création de la page d'accueil (affichage de tous les posts)
class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cht'i Face Bouc"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ServiceFirestore().allPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            if (docs.isEmpty) return const EmptyBody();
            
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final Post post = Post(
                  reference: docs[index].reference,
                  id: docs[index].id,
                  map: docs[index].data() as Map<String, dynamic>
                );
                return WidgetPost(post: post);
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
