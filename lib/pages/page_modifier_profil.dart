import 'package:flutter/material.dart';
import '../modeles/membre.dart';
import '../modeles/constantes.dart';
import '../services_firebase/service_firestore.dart';
import '../services_firebase/service_authentification.dart';

class PageModifierProfil extends StatefulWidget {
  final Membre member;
  const PageModifierProfil({super.key, required this.member});

  @override
  State<PageModifierProfil> createState() => _PageModifierProfilState();
}

class _PageModifierProfilState extends State<PageModifierProfil> {
  // a) Les variables
  late TextEditingController surnameController;
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  // b) Les méthodes initState() et dispose()
  @override
  void initState() {
    super.initState();
    surnameController = TextEditingController(text: widget.member.surname);
    nameController = TextEditingController(text: widget.member.name);
    descriptionController = TextEditingController(text: widget.member.description);
  }

  @override
  void dispose() {
    surnameController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // d) La fonction _onValidate
  void _onValidate() {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<String, dynamic> data = {};
    
    if (nameController.text.isNotEmpty && nameController.text != widget.member.name) {
      data[nameKey] = nameController.text;
    }
    if (surnameController.text.isNotEmpty && surnameController.text != widget.member.surname) {
      data[surnameKey] = surnameController.text;
    }
    if (descriptionController.text != widget.member.description) {
      data[descriptionKey] = descriptionController.text;
    }

    if (data.isNotEmpty) {
      ServiceFirestore().updateMember(id: widget.member.id, data: data);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le profil"),
        actions: [
          TextButton(
            onPressed: _onValidate,
            child: const Text("Valider", style: TextStyle(color: Colors.brown)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: surnameController,
              decoration: const InputDecoration(labelText: "Prénom"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Déconnexion"),
                      content: const Text("Voulez vous vous déconnecter ?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), 
                          child: const Text("NON")
                        ),
                        TextButton(
                          onPressed: () {
                            ServiceAuthentification().signOut();
                            Navigator.pop(context); // Ferme le dialog
                            Navigator.pop(context); // Ferme la page de modification
                          }, 
                          child: const Text("OUI")
                        ),
                      ],
                    );
                  }
                );
              }, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
              child: const Text("Se déconnecter", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
