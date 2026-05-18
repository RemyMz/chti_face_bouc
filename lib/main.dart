import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/page_applicationl.dart';

/// Point d'entrée principal de l'application Chti Face Bouc.
/// Initialise Firebase et lance le widget racine.
void main() async {
  // Assure l'initialisation des bindings Flutter avant d'appeler du code asynchrone
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation de Firebase avec les options spécifiques à la plateforme (iOS, Android, Web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

/// Widget racine de l'application.
/// Configure le thème global et définit la page de démarrage.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chti Face Bouc",
      debugShowCheckedModeBanner: false,
      // Configuration du thème utilisant Material 3 et une couleur de base marron/terre
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      // Redirection vers le gestionnaire d'état de l'application (Auth vs Accueil)
      home: const PageApplicationl(),
    );
  }
}
