import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return StreamBuilder<DocumentSnapshot>(
      // Récupère les données du membre en temps réel
      stream: ServiceFirestore().specificMember(memberId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) return const SizedBox();
        
        final data = snapshot.data!;
        final Membre member = Membre(
          reference: data.reference, 
          id: data.id, 
          map: data.data() as Map<String, dynamic>
        );

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
