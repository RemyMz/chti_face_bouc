import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/post.dart';
import '../widgets/widget_post.dart';
import '../widgets/widget_vide.dart';

/// Page d'accueil affichant le flux de toutes les publications du réseau social.
class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Écoute en temps réel de toutes les publications via Firestore
      stream: ServiceFirestore().allPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          // Affiche un widget spécifique si aucune publication n'est trouvée
          if (docs.isEmpty) return const EmptyBody();
          
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              // Conversion du document Firestore en objet Post
              final Post post = Post(
                reference: docs[index].reference,
                id: docs[index].id,
                map: docs[index].data() as Map<String, dynamic>
              );
              return WidgetPost(post: post);
            },
          );
        } else {
          // Chargement en cours
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
