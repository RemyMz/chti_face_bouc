import 'dart:ui';
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

/// Page principale gérant la navigation par onglets avec effets de flou (Glassmorphism).
class PageNavigation extends StatefulWidget {
  const PageNavigation({super.key});

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final memberId = ServiceAuthentification().myId;
    if (memberId == null) return const EmptyScaffold();

    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(memberId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData && snapshot.data?.data() != null) {
          final data = snapshot.data!;
          final Membre member = Membre(
            reference: data.reference, 
            id: data.id, 
            map: data.data() as Map<String, dynamic>
          );

          List<String> titles = ["Fil d'actualité", "La Communauté", "Nouvelle Publication", "Notifications", "Mon Profil"];
          List<Widget> bodies = [
            const PageAccueil(),
            const PageMembres(),
            PageEcrirePost(member: member, onPostSent: (newIndex) => setState(() => index = newIndex)),
            PageNotif(member: member),
            PageProfil(member: member),
          ];

          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: index == 4 ? null : PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: AppBar(
                    title: Text(titles[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            body: IndexedStack(index: index, children: bodies),
            bottomNavigationBar: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.6),
                    border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5)),
                  ),
                  child: NavigationBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    indicatorColor: Theme.of(context).primaryColor.withOpacity(0.15),
                    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                    selectedIndex: index,
                    onDestinationSelected: (int newValue) => setState(() => index = newValue),
                    destinations: const [
                      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: "Accueil"),
                      NavigationDestination(icon: Icon(Icons.group_outlined), selectedIcon: Icon(Icons.group_rounded), label: "Membres"),
                      NavigationDestination(icon: Icon(Icons.add_circle_outline_rounded), selectedIcon: Icon(Icons.add_circle_rounded), label: "Ecrire"),
                      NavigationDestination(icon: Icon(Icons.notifications_none_rounded), selectedIcon: Icon(Icons.notifications_rounded), label: "Notification"),
                      NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: "Profil"),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const EmptyScaffold();
        }
      },
    );
  }
}
