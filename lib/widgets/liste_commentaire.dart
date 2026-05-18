import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeles/post.dart';
import '../modeles/commentaire.dart';
import '../services_firebase/service_firestore.dart';
import '../widgets/entete_membre.dart';

class ListeCommentaire extends StatelessWidget {
  final Post post;
  const ListeCommentaire({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ServiceFirestore().postComment(postId: post.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Pas encore de commentaires..."),
            ),
          );
        }
        final docs = snapshot.data!.docs;
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final Commentaire comment = Commentaire(
              reference: docs[index].reference, 
              id: docs[index].id, 
              map: docs[index].data() as Map<String, dynamic>
            );
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EnteteMembre(memberId: comment.member, date: comment.date),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 5),
                    child: Text(comment.text),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
