import 'package:flutter/material.dart';
import '../modeles/post.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import '../pages/page_detail_post.dart';
import '../modeles/donnees.dart';
import 'entete_membre.dart';
import 'contenu_post.dart';

/// Widget principal affichant une publication sous forme de carte.
/// Gère les interactions (Like, Commenter) et l'affichage complet du contenu.
class WidgetPost extends StatelessWidget {
  /// La publication à afficher.
  final Post post;
  const WidgetPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            // Section En-tête (Avatar + Nom + Date)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EnteteMembre(memberId: post.memberId, date: post.date),
            ),
            
            // Section Contenu (Image + Texte)
            ContenuPost(post: post),

            const Divider(),

            // Barre d'actions (Likes et Commentaires)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        final myId = ServiceAuthentification().myId;
                        if (myId != null) {
                          // Gère l'ajout/suppression d'un Like
                          ServiceFirestore().addLike(memberID: myId, post: post);
                        }
                      }, 
                      icon: Icon(
                        Icons.star, 
                        color: post.likes.contains(ServiceAuthentification().myId) 
                          ? Colors.orange 
                          : Colors.grey
                      )
                    ),
                    const Text(Donnees.likeLabel, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Text("${post.likes.length} Likes"),
                IconButton(
                  onPressed: () {
                    // Navigation vers le détail de la publication
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PageDetailPost(post: post)
                    ));
                  }, 
                  icon: const Icon(Icons.messenger_outline)
                ),
                const Text("Commenter"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
