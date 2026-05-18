import 'package:flutter/material.dart';
import '../modeles/donnees.dart';

/// Widget affiché lorsqu'aucune donnée n'est disponible dans une liste.
class EmptyBody extends StatelessWidget {
  const EmptyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.feed_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            Donnees.noDataMessage,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Écran de secours affiché en cas d'erreur d'identification ou d'absence de données critiques.
class EmptyScaffold extends StatelessWidget {
  const EmptyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const EmptyBody(),
    );
  }
}
