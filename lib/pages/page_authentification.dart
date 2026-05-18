import 'package:flutter/material.dart';
import '../services_firebase/service_authentification.dart';

class PageAuthentification extends StatefulWidget {
  const PageAuthentification({super.key});

  @override
  State<PageAuthentification> createState() => _PageAuthentificationState();
}

class _PageAuthentificationState extends State<PageAuthentification> {
  // a) Les variables
  bool accountExists = true; // true = connexion, false = création
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  // b) Les méthodes initState() et dispose()
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    surnameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  // d) La fonction _onSelectedChanged
  void _onSelectedChanged(Set<bool> newValue) {
    setState(() {
      accountExists = newValue.first;
    });
  }

  // e) La fonction _handleHauth
  void _handleHauth() async {
    final auth = ServiceAuthentification();
    String? result;
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

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Colors.red),
      );
    }
  }

  // c) La méthode build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // 1. Image (Logo) - Utilisation d'une icône en attendant le logo
              const Icon(Icons.account_circle, size: 120, color: Colors.brown),
              const SizedBox(height: 20),

              // 2. SegmentedButton
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text("Créer un compte"),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text("S'y connecter"),
                  ),
                ],
                selected: <bool>{accountExists},
                onSelectionChanged: _onSelectedChanged,
              ),
              const SizedBox(height: 20),

              // 3. Card > Container > Column > TextFields
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: mailController,
                        decoration: const InputDecoration(labelText: 'Adresse mail'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: 'Mot de passe'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      if (!accountExists) ...[
                        TextField(
                          controller: surnameController,
                          decoration: const InputDecoration(labelText: 'Prénom'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Nom'),
                        ),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _handleHauth,
                        child: Text(accountExists ? "Se connecter" : "Créer mon compte"),
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
