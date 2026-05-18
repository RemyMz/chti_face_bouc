import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/post.dart';
import '../widgets/widget_post.dart';
import '../widgets/widget_vide.dart';

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: ServiceFirestore().allPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _ShimmerLoading();
          }
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            if (docs.isEmpty) return const EmptyBody();
            
            return ListView.builder(
              padding: const EdgeInsets.only(top: 100, bottom: 100), // Top pour l'AppBar, Bottom pour la Nav gless
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
            return const EmptyBody();
          }
        },
      ),
    );
  }
}

class _ShimmerLoading extends StatelessWidget {
  const _ShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.grey.withOpacity(0.05),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
