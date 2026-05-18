import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../modeles/membre.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/donnees.dart';

/// Page permettant à l'utilisateur de rédiger et publier une nouvelle publication.
class PageEcrirePost extends StatefulWidget {
  /// Le membre qui écrit le post.
  final Membre member;
  
  /// Callback appelé une fois le post envoyé (généralement pour rediriger vers l'accueil).
  final Function(int) onPostSent;

  const PageEcrirePost({super.key, required this.member, required this.onPostSent});

  @override
  State<PageEcrirePost> createState() => _PageEcrirePostState();
}

class _PageEcrirePostState extends State<PageEcrirePost> {
  late TextEditingController textController;
  late TextEditingController locationController;
  dynamic imageFile; // Utilisation de dynamic pour la compatibilité Web/Mobile
  Uint8List? webImage;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    locationController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    locationController.dispose();
    super.dispose();
  }

  /// Ouvre la source sélectionnée (galerie ou caméra) pour choisir une image.
  void _takePic(ImageSource source) async {
    final XFile? xfile = await ImagePicker().pickImage(source: source, maxWidth: 500);
    if (xfile != null) {
      if (kIsWeb) {
        // Gestion spécifique pour le Web (Uint8List)
        final bytes = await xfile.readAsBytes();
        setState(() {
          webImage = bytes;
        });
      } else {
        // Gestion pour Mobile (File)
        setState(() {
          imageFile = File(xfile.path);
        });
      }
    }
  }

  /// Récupère la position actuelle de l'appareil et extrait le nom de la ville.
  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si le service de localisation est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    // Vérifie et demande les permissions si nécessaire
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    if (permission == LocationPermission.deniedForever) return;

    try {
      // Configuration pour une précision élevée
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
      
      // Récupération de la position GPS avec les réglages
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings
      );
      
      // Reverse geocoding avec gestion d'erreur spécifique
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            locationController.text = place.locality ?? place.subAdministrativeArea ?? place.name ?? "";
          });
        }
      } catch (geocodingError) {
        // Si le geocoding échoue (ex: pas de service), on met au moins les coordonnées ou on laisse vide
        debugPrint("Erreur Geocoding : $geocodingError");
        setState(() {
          locationController.text = "${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}";
        });
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération de la position : $e");
    }
  }

  /// Valide et envoie la publication vers Firestore et Storage.
  void _sendPost() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (textController.text.isEmpty) return;

    await ServiceFirestore().createPost(
      widget.member, 
      textController.text, 
      locationController.text,
      imageFile,
      webImage
    );

    // Retour au flux (index 0 de la navigation)
    widget.onPostSent(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100, bottom: 100),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.border_color),
                        SizedBox(width: 10),
                        Text("Ecrire un post", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(),
                    TextField(
                      controller: textController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: Donnees.welcomeMessage,
                        border: InputBorder.none
                      ),
                    ),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        hintText: "Localisation (Ville, lieu...)",
                        prefixIcon: Icon(Icons.location_on, size: 16),
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 14)
                      ),
                    ),
                    const Divider(),
                    // Affichage de l'aperçu de l'image sélectionnée
                    if (webImage != null || imageFile != null) ...[
                      const SizedBox(height: 10),
                      if (kIsWeb && webImage != null)
                        Image.memory(webImage!, height: 150)
                      else if (imageFile != null)
                        Image.file(imageFile!, height: 150),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () => _takePic(ImageSource.gallery), 
                          icon: const Icon(Icons.photo_library)
                        ),
                        IconButton(
                          onPressed: () => _takePic(ImageSource.camera), 
                          icon: const Icon(Icons.camera_alt)
                        ),
                        IconButton(
                          onPressed: _getCurrentLocation, 
                          icon: const Icon(Icons.my_location, color: Colors.blue)
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _sendPost, 
                      child: const Text("Envoyer")
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
