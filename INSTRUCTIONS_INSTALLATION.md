# Instructions d'Installation - Projet Cht'i Face Bouc

Ce projet est une application Flutter utilisant Firebase (Auth, Firestore, Storage). Pour le faire fonctionner de votre côté, voici les étapes à suivre :

## 1. Configuration Firebase
L'application nécessite un projet Firebase actif. Vous devez :
1. Créer un projet sur la [Console Firebase](https://console.firebase.google.com/).
2. Activer les services suivants :
   - **Authentication** (activer la méthode "E-mail/Mot de passe").
   - **Cloud Firestore** (en mode production ou test, avec les règles d'accès appropriées).
   - **Firebase Storage** (pour le stockage des photos de profil et des posts).

## 2. Liaison de l'application
Pour des raisons de sécurité, les fichiers de configuration contenant les clés API (`google-services.json` et `firebase_options.dart`) sont ignorés par Git.

### Générer les options Firebase 
Exécutez la commande suivante à la racine du projet (nécessite [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)) :
```bash
flutterfire configure
```
Cela générera automatiquement le fichier `lib/firebase_options.dart` nécessaire au lancement.

## 3. Base de données Firestore
Par défaut, l'application est configurée pour utiliser la base de données **`(default)`**.

Si vous utilisez une base de données avec un identifiant spécifique (ex: `defo`), modifiez la configuration dans `lib/services_firebase/service_firestore.dart` :
```dart
static final firestore = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'defo');
```

## 4. Lancement
Une fois la configuration terminée :
```bash
flutter pub get
flutter run
```

---
**Développé par :** MAZINGUE Rémy
