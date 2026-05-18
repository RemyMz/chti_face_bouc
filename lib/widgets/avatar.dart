import 'package:flutter/material.dart';

/// Widget affichant la photo de profil d'un utilisateur dans un cercle.
/// Affiche un logo par défaut si aucune URL d'image n'est fournie.
class Avatar extends StatelessWidget {
  /// Rayon du cercle de l'avatar.
  final double radius;
  
  /// URL de l'image de profil (optionnelle).
  final String? url;

  const Avatar({super.key, required this.radius, this.url});

  @override
  Widget build(BuildContext context) {
    bool hasImage = (url != null && url!.isNotEmpty);
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.brown.shade100,
      backgroundImage: hasImage ? NetworkImage(url!) : null,
      // Affiche le logo Flutter en guise de placeholder
      child: hasImage ? null : FlutterLogo(size: radius),
    );
  }
}
