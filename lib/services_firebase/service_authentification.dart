import 'package:firebase_auth/firebase_auth.dart';
import 'service_firestore.dart';

class ServiceAuthentification {
  final _auth = FirebaseAuth.instance;

  // Récupérer l'uid unique de l'utilisateur
  String? get myId => _auth.currentUser?.uid;

  // Stream pour l'état de l'authentification
  Stream<User?> get userStream => _auth.authStateChanges();

  // Connexion à Firebase
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Créer un compte sur Firebase
  Future<String?> createAccount(String email, String password, String surname, String name) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // Etape 3.5 : Appel de la méthode addMember
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

  // Déconnecter de Firebase
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Voir si vous êtes l'utilisateur
  bool isMe(String profileId) {
    return profileId == myId;
  }
}
