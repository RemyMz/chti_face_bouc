import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/membre.dart';
import 'formatage_date.dart';
import 'avatar.dart';

class EnteteMembre extends StatelessWidget {
  final String memberId;
  final int date;

  const EnteteMembre({super.key, required this.memberId, required this.date});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
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
