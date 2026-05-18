import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'page_authentification.dart';
import 'page_navigation.dart';

/// Page racine de l'application gérant l'aiguillage automatique.
/// Elle détermine si l'utilisateur doit voir la page d'authentification ou l'application principale.
class PageApplicationl extends StatefulWidget {
  const PageApplicationl({super.key});

  @override
  State<PageApplicationl> createState() => _PageApplicationlState();
}

class _PageApplicationlState extends State<PageApplicationl> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Écoute les changements d'état de l'utilisateur (connexion/déconnexion)
      stream: FirebaseAuth.instance.userChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // L'utilisateur est connecté
          return const PageNavigation();
        } else {
          // L'utilisateur n'est pas connecté
          return const PageAuthentification();
        }
      },
    );
  }
}
