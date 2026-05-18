import 'package:flutter/material.dart';
import '../modeles/donnees.dart';

/// Widget affiché lorsqu'aucune donnée n'est disponible dans une liste.
class EmptyBody extends StatelessWidget {
  const EmptyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(Donnees.noDataMessage),
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
