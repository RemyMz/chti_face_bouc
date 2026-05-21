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
Vous avez deux options pour configurer les clefs API :

### Utiliser FlutterFire CLI 
Exécutez la commande suivante à la racine du projet pour générer automatiquement le fichier `lib/firebase_options.dart` :
```bash
flutterfire configure
```


## 3. Base de données Firestore
Par défaut, l'application utilise la base de données **`(default)`**.
Si vous souhaitez utiliser une base de données avec un ID spécifique, vous pouvez modifier le fichier `lib/services_firebase/service_firestore.dart` à la ligne 16 :
```dart
static final instance = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'VOTRE_ID');
```

## 4. Lancement
Une fois la configuration terminée :
```bash
flutter pub get
flutter run
```

---
**Développé par :** MAZINGUE Rémy