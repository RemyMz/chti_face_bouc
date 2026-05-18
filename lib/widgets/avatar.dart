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
    
    return Hero(
      tag: url ?? "avatar_${DateTime.now().millisecondsSinceEpoch}",
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).cardColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: ClipOval(
            child: hasImage 
              ? Image.network(
                  url!,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: radius, color: Theme.of(context).colorScheme.onPrimaryContainer),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  },
                )
              : Icon(Icons.person, size: radius, color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
      ),
    );
  }
}
