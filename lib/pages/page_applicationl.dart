import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'page_authentification.dart';
import 'page_navigation.dart';

// Gère l'aiguillage entre Authentification et Navigation
class PageApplicationl extends StatefulWidget {
  const PageApplicationl({super.key});

  @override
  State<PageApplicationl> createState() => _PageApplicationlState();
}

class _PageApplicationlState extends State<PageApplicationl> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return const PageNavigation();
        } else {
          return const PageAuthentification();
        }
      },
    );
  }
}
