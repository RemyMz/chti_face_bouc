import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/page_application.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.05),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            elevation: 0,
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
          color: Colors.grey.shade900,
        ),
      ),
      themeMode: ThemeMode.system,
      // Redirection vers le gestionnaire d'état de l'application (Auth vs Accueil)
      home: const PageApplication(),
    );
  }
}
