import 'package:flutter/material.dart';
import '../modeles/post.dart';

/// Widget responsable de l'affichage du contenu d'une publication (image et texte).
class ContenuPost extends StatelessWidget {
  /// La publication dont le contenu doit être affiché.
  final Post post;
  const ContenuPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Affiche l'image de la publication si elle existe
        if (post.imageUrl.isNotEmpty) ...[
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(post.imageUrl, fit: BoxFit.cover),
          ),
        ],

        // Affiche le texte de la publication
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              post.text, 
              style: const TextStyle(fontSize: 16)
            ),
          ),
        ),
      ],
    );
  }
}
