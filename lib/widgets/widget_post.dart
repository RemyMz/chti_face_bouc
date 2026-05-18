import 'package:flutter/material.dart';
import '../modeles/post.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import '../pages/page_detail_post.dart';
import '../pages/page_modifier_post.dart';
import '../modeles/donnees.dart';
import 'entete_membre.dart';
import 'contenu_post.dart';

/// Widget principal affichant une publication sous forme de carte moderne et arrondie.
class WidgetPost extends StatelessWidget {
  /// La publication à afficher.
  final Post post;
  const WidgetPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Section En-tête (Avatar + Nom + Date)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: EnteteMembre(memberId: post.memberId, date: post.date, location: post.location),
                  ),
                  if (ServiceAuthentification().isMe(post.memberId))
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz, color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      onSelected: (value) async {
                        if (value == 'delete') {
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: const Text("Supprimer le post ?"),
                              content: const Text("Cette action est irréversible."),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Supprimer", style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            ServiceFirestore().deletePost(post);
                          }
                        } else if (value == 'edit') {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => PageModifierPost(post: post)
                          ));
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit_outlined), title: Text("Modifier"))),
                        const PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete_outline, color: Colors.red), title: Text("Supprimer", style: TextStyle(color: Colors.red)))),
                      ],
                    ),
                ],
              ),
            ),
            
            // Section Contenu (Image + Texte)
            ContenuPost(post: post),

            // Affichage de la localisation
            if (post.location.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      post.location,
                      style: TextStyle(
                        fontSize: 12, 
                        color: Theme.of(context).primaryColor.withOpacity(0.8), 
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1, thickness: 0.5),
            ),

            // Barre d'actions moderne
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  context,
                  icon: post.likes.contains(ServiceAuthentification().myId) ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: post.likes.contains(ServiceAuthentification().myId) ? Colors.orange : Colors.grey,
                  label: "${post.likes.length} ${Donnees.likeLabel}",
                  onTap: () {
                    final myId = ServiceAuthentification().myId;
                    if (myId != null) {
                      ServiceFirestore().addLike(memberID: myId, post: post);
                    }
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.chat_bubble_outline_rounded,
                  color: Colors.grey,
                  label: "Commenter",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PageDetailPost(post: post)
                    ));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
