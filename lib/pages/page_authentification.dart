import 'package:flutter/material.dart';
import '../services_firebase/service_authentification.dart';

/// Page gérant l'authentification des utilisateurs (Connexion et Création de compte).
class PageAuthentification extends StatefulWidget {
  const PageAuthentification({super.key});

  @override
  State<PageAuthentification> createState() => _PageAuthentificationState();
}

class _PageAuthentificationState extends State<PageAuthentification> {
  /// Détermine si l'utilisateur tente de se connecter (true) ou de créer un compte (false).
  bool accountExists = true;

  // Contrôleurs pour les champs de saisie
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Libération des ressources des contrôleurs
    mailController.dispose();
    passwordController.dispose();
    surnameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  /// Change l'état entre "Connexion" et "Création de compte".
  void _onSelectedChanged(Set<bool> newValue) {
    setState(() {
      accountExists = newValue.first;
    });
  }

  /// Gère l'action principale d'authentification en appelant le service Firebase.
  void _handleHauth() async {
    final auth = ServiceAuthentification();
    String? result;
    
    // Appel du service approprié selon l'état actuel
    if (accountExists) {
      result = await auth.signIn(mailController.text, passwordController.text);
    } else {
      result = await auth.createAccount(
        mailController.text, 
        passwordController.text, 
        surnameController.text, 
        nameController.text
      );
    }

    // Affichage d'une erreur si l'authentification échoue
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result), 
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Titre en jargon local
              const Text(
                "T'in pour commincher",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              const SizedBox(height: 10),
              // Logo ou Icône représentative
              const Icon(Icons.account_circle, size: 120, color: Colors.brown),
              const SizedBox(height: 20),

              // Sélecteur entre Connexion et Inscription
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text("Créer tin compte"),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text("y va connecter"),
                  ),
                ],
                selected: <bool>{accountExists},
                onSelectionChanged: _onSelectedChanged,
              ),
              const SizedBox(height: 20),

              // Formulaire d'authentification
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: mailController,
                        decoration: const InputDecoration(
                          labelText: 'Adresse mail',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      // Champs supplémentaires affichés uniquement lors de la création de compte
                      if (!accountExists) ...[
                        TextField(
                          controller: surnameController,
                          decoration: const InputDecoration(
                            labelText: 'Prénom',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nom',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      // Bouton de validation
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleHauth,
                          child: Text(accountExists ? "Se connecter" : "Créer mon compte"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
