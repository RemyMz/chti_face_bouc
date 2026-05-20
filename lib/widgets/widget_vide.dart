import 'package:flutter/material.dart';
import '../modeles/donnees.dart';
import '../services_firebase/service_authentification.dart';

/// Widget affiché lorsqu'aucune donnée n'est disponible dans une liste.
class EmptyBody extends StatelessWidget {
  final String? message;
  const EmptyBody({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message ?? Donnees.noDataMessage),
    );
  }
}

/// Écran de secours affiché en cas d'erreur d'identification ou d'absence de données critiques.
class EmptyScaffold extends StatelessWidget {
  final String? message;
  const EmptyScaffold({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => ServiceAuthentification().signOut(), 
            icon: const Icon(Icons.logout),
            tooltip: "Se déconnecter",
          )
        ],
      ),
      body: EmptyBody(message: message),
    );
  }
}
