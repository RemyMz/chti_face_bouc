import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/membre.dart';
import '../widgets/widget_vide.dart';
import '../modeles/donnees.dart';
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
      stream: ServiceFirestore().specificMember(memberId),
      builder: (context, snapshot) {
        // On récupère les données si elles existent, sinon on crée un membre "temporaire"
        Membre? member;
        if (snapshot.hasData && snapshot.data?.data() != null) {
          final data = snapshot.data!;
          member = Membre(
            reference: data.reference, 
            id: data.id, 
            map: data.data() as Map<String, dynamic>
          );
        }

        // Liste des pages disponibles dans la navigation
        // On gère le cas où le profil n'est pas encore créé/chargé
        List<Widget> bodies = [
          const PageAccueil(),
          const PageMembres(),
          member != null 
            ? PageEcrirePost(member: member, onPostSent: (newIndex) => setState(() => index = newIndex))
            : const EmptyBody(message: "Chargement de votre profil pour poster..."),
          member != null 
            ? PageNotif(member: member)
            : const EmptyBody(message: "Chargement des notifications..."),
          member != null 
            ? PageProfil(member: member)
            : const EmptyScaffold(message: Donnees.errorProfile), // On utilise EmptyScaffold ici pour le bouton déconnexion
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(member?.fullName ?? "Chti Face Bouc"),
            actions: [
              if (index == 0) // Uniquement sur l'accueil
                IconButton(
                  tooltip: Donnees.refreshLabel,
                  onPressed: () => setState(() {}), 
                  icon: const Icon(Icons.refresh)
                ),
              if (member == null)
                IconButton(
                  onPressed: () => ServiceAuthentification().signOut(), 
                  icon: const Icon(Icons.logout)
                )
            ],
          ),
          body: snapshot.connectionState == ConnectionState.waiting && member == null
            ? const Center(child: CircularProgressIndicator())
            : bodies[index],
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
      },
    );
  }
}
