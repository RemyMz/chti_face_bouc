import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../modeles/post.dart';
import '../services_firebase/service_firestore.dart';

/// Page permettant à l'utilisateur de modifier une publication existante.
class PageModifierPost extends StatefulWidget {
  final Post post;
  const PageModifierPost({super.key, required this.post});

  @override
  State<PageModifierPost> createState() => _PageModifierPostState();
}

class _PageModifierPostState extends State<PageModifierPost> {
  late TextEditingController textController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.post.text);
    locationController = TextEditingController(text: widget.post.location);
  }

  @override
  void dispose() {
    textController.dispose();
    locationController.dispose();
    super.dispose();
  }

  /// Récupère la position actuelle pour mettre à jour la localisation.
  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    if (permission == LocationPermission.deniedForever) return;

    try {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings
      );

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            locationController.text = place.locality ?? place.subAdministrativeArea ?? place.name ?? "";
          });
        }
      } catch (geocodingError) {
        debugPrint("Erreur Geocoding : $geocodingError");
        setState(() {
          locationController.text = "${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}";
        });
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération de la position : $e");
    }
  }

  /// Enregistre les modifications.
  void _onValidate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (textController.text.isEmpty) return;

    await ServiceFirestore().updatePost(
      post: widget.post, 
      text: textController.text.trim(), 
      location: locationController.text.trim()
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le post"),
        actions: [
          IconButton(
            onPressed: _onValidate, 
            icon: const Icon(Icons.check)
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            if (widget.post.imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Image.network(widget.post.imageUrl, height: 200, fit: BoxFit.cover),
              ),
            TextField(
              controller: textController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "Localisation",
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton(
                  onPressed: _getCurrentLocation, 
                  icon: const Icon(Icons.my_location)
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
