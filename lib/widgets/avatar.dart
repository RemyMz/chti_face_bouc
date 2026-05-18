import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double radius;
  final String? url;

  const Avatar({super.key, required this.radius, this.url});

  @override
  Widget build(BuildContext context) {
    bool hasImage = (url != null && url!.isNotEmpty);
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.brown.shade100,
      backgroundImage: hasImage ? NetworkImage(url!) : null,
      child: hasImage ? null : FlutterLogo(size: radius), // Exigence Etape 6.5
    );
  }
}
