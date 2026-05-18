import 'package:flutter/material.dart';
import '../modeles/post.dart';

class ContenuPost extends StatelessWidget {
  final Post post;
  const ContenuPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image du post (si présente)
        if (post.imageUrl.isNotEmpty) ...[
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(post.imageUrl, fit: BoxFit.cover),
          ),
        ],

        // Texte du post
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
