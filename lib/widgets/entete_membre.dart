import 'package:flutter/material.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/membre.dart';
import 'formatage_date.dart';
import 'avatar.dart';

/// Widget affichant les informations de l'auteur d'une publication ou d'un commentaire.
/// Affiche l'avatar, le nom complet et la date formatée.
class EnteteMembre extends StatelessWidget {
  /// Identifiant du membre à afficher.
  final String memberId;
  
  /// Date associée (publication ou commentaire) au format timestamp.
  final int date;

  const EnteteMembre({super.key, required this.memberId, required this.date});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Membre?>(
      // Récupère les données du membre une seule fois
      future: ServiceFirestore().getMember(memberId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) return const SizedBox();
        
        final Membre member = snapshot.data!;

        return Row(
          children: [
            Avatar(radius: 15, url: member.profilePicture),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  // Utilise l'utilitaire de formatage pour une date lisible
                  FormatageDate().formatted(date), 
                  style: const TextStyle(fontSize: 10, color: Colors.grey)
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
