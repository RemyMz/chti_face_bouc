import 'package:flutter/material.dart';
import '../modeles/post.dart';
import '../services_firebase/service_firestore.dart';
import '../widgets/widget_post.dart';
import '../widgets/liste_commentaire.dart';

/// Page affichant les détails d'une publication ainsi que ses commentaires.
class PageDetailPost extends StatefulWidget {
  /// La publication à afficher en détail.
  final Post post;
  const PageDetailPost({super.key, required this.post});

  @override
  State<PageDetailPost> createState() => _PageDetailPostState();
}

class _PageDetailPostState extends State<PageDetailPost> {
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  /// Gère l'envoi d'un nouveau commentaire.
  void _handleSend() {
    if (commentController.text.trim().isEmpty) return;
    ServiceFirestore().addComment(post: widget.post, text: commentController.text.trim());
    commentController.clear();
    // Ferme le clavier après l'envoi
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Commentaires"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Rappel de la publication originale
            WidgetPost(post: widget.post),
            
            // Champ de saisie pour ajouter un commentaire
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: "Ajouter un commentaire...",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _handleSend, 
                    icon: const Icon(Icons.send, color: Colors.brown)
                  ),
                ],
              ),
            ),

            // Liste des commentaires existants récupérés en temps réel
            ListeCommentaire(post: widget.post),
          ],
        ),
      ),
    );
  }
}
