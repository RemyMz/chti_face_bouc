import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../modeles/membre.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/donnees.dart';

class PageEcrirePost extends StatefulWidget {
  final Membre member;
  final Function(int) onPostSent;

  const PageEcrirePost({super.key, required this.member, required this.onPostSent});

  @override
  State<PageEcrirePost> createState() => _PageEcrirePostState();
}

class _PageEcrirePostState extends State<PageEcrirePost> {
  // a) Les variables
  late TextEditingController textController;
  File? imageFile;
  Uint8List? webImage;

  // b) Les méthodes initState() et dispose()
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // e) La fonction _takePic
  void _takePic(ImageSource source) async {
    final XFile? xfile = await ImagePicker().pickImage(source: source, maxWidth: 500);
    if (xfile != null) {
      if (kIsWeb) {
        final bytes = await xfile.readAsBytes();
        setState(() {
          webImage = bytes;
        });
      } else {
        setState(() {
          imageFile = File(xfile.path);
        });
      }
    }
  }

  // d) La fonction _sendPost
  void _sendPost() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (textController.text.isEmpty) return;

    await ServiceFirestore().createPost(
      widget.member, 
      textController.text, 
      imageFile,
      webImage
    );

    // Retour au flux (index 0)
    widget.onPostSent(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chti Face Bouc"),
      ),
      body: SingleChildScrollView(
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
