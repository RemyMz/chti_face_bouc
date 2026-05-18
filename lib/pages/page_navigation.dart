import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/membre.dart';
import '../widgets/widget_vide.dart';
import 'page_accueil.dart';
import 'page_membres.dart';
import 'page_ecrire_post.dart';
import 'page_profil.dart';
import 'page_notif.dart';

/// Page principale gérant la navigation par onglets (BottomNavigationBar).
/// Elle charge les données de l'utilisateur connecté et orchestre l'affichage des différentes sections.
class PageNavigation extends StatefulWidget {
  const PageNavigation({super.key});

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  /// Index de l'onglet actuellement sélectionné.
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final memberId = ServiceAuthentification().myId;
    
    // Si l'utilisateur n'est pas identifié, on affiche un écran vide sécurisé
    if (memberId == null) return const EmptyScaffold();

    return StreamBuilder<DocumentSnapshot>(
      // Récupère les informations détaillées du membre connecté
      stream: ServiceFirestore().specificMember(memberId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data?.data() != null) {
          final data = snapshot.data!;
          final Membre member = Membre(
            reference: data.reference, 
            id: data.id, 
            map: data.data() as Map<String, dynamic>
          );

          // Liste des pages disponibles dans la navigation
          List<Widget> bodies = [
            const PageAccueil(),
            const PageMembres(),
            PageEcrirePost(member: member, onPostSent: (newIndex) {
              // Callback pour changer d'onglet après publication d'un post
              setState(() {
                index = newIndex;
              });
            }),
            PageNotif(member: member),
            PageProfil(member: member),
          ];

          return Scaffold(
            appBar: AppBar(
              title: Text(member.fullName),
            ),
            body: bodies[index],
            bottomNavigationBar: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: index,
              onDestinationSelected: (int newValue) {
                setState(() {
                  index = newValue;
                });
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: "Accueil"),
                NavigationDestination(icon: Icon(Icons.group), label: "Membres"),
                NavigationDestination(icon: Icon(Icons.border_color), label: "Ecrire"),
                NavigationDestination(icon: Icon(Icons.notifications), label: "Notification"),
                NavigationDestination(icon: Icon(Icons.person), label: "Profil"),
              ],
            ),
          );
        } else {
          return const EmptyScaffold();
        }
      },
    );
  }
}
