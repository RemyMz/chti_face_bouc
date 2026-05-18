import 'package:firebase_auth/firebase_auth.dart';
import 'service_firestore.dart';

/// Service gérant l'authentification des utilisateurs avec Firebase Auth.
class ServiceAuthentification {
  final _auth = FirebaseAuth.instance;

  /// Récupère l'identifiant unique (UID) de l'utilisateur actuellement connecté.
  String? get myId => _auth.currentUser?.uid;

  /// Flux (Stream) permettant d'écouter les changements d'état de l'authentification.
  Stream<User?> get userStream => _auth.authStateChanges();

  /// Connecte un utilisateur avec son email et son mot de passe.
  /// Retourne un message d'erreur en cas d'échec, sinon null.
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Crée un nouveau compte utilisateur et initialise ses données dans Firestore.
  /// Retourne un message d'erreur en cas d'échec, sinon null.
  Future<String?> createAccount(String email, String password, String surname, String name) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // Création du profil utilisateur dans Firestore après succès de l'auth
      if (credential.user != null) {
        Map<String, dynamic> data = {
          'uid': credential.user!.uid,
          'email': email,
          'surname': surname,
          'name': name,
        };
        ServiceFirestore().addMember(id: credential.user!.uid, data: data);
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Déconnecte l'utilisateur actuel de Firebase.
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Vérifie si l'identifiant fourni correspond à l'utilisateur actuellement connecté.
  bool isMe(String profileId) {
    return profileId == myId;
  }
}
