# Chti Face Bouc 👨‍🌾💻

**Chti Face Bouc** est une application mobile sociale développée avec **Flutter** et **Firebase**, conçue pour connecter les gens avec une touche locale. Le projet a été réalisé dans le cadre du module de développement mobile à l'IMT.

## 🚀 Fonctionnalités

L'application offre une expérience sociale complète incluant :

- **Authentification sécurisée** : Inscription et connexion via Firebase Auth.
- **Profil Utilisateur** : Personnalisation du profil avec photo (via `image_picker`), bio et informations personnelles.
- **Fil d'actualité** : Visualisation des posts de la communauté en temps réel.
- **Création de contenu** : Publication de messages texte et partage d'images.
- **Interactions** : Système de likes et commentaires sur les posts.
- **Membres** : Liste des utilisateurs inscrits pour découvrir de nouvelles personnes.
- **Notifications** : Suivi des interactions récentes.
- **Stockage Cloud** : Utilisation de Firebase Storage pour les images et Firestore pour les données.

## 🛠️ Stack Technique

- **Framework** : [Flutter](https://flutter.dev/) (Dart)
- **Backend** : [Firebase](https://firebase.google.com/)
  - Authentication (Gestion des utilisateurs)
  - Firestore (Base de données NoSQL en temps réel)
  - Cloud Storage (Stockage des images de profil et des posts)
- **Packages principaux** :
  - `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
  - `image_picker` (Galerie/Appareil photo)
  - `intl` (Formatage des dates)

## 📦 Installation et Lancement

1. **Prérequis** :
   - Flutter SDK installé
   - Un projet Firebase configuré

2. **Cloner le dépôt** :
   ```bash
   git clone https://github.com/RemyMz/chti_face_bouc.git
   cd chti_face_bouc
   ```

3. **Installer les dépendances** :
   ```bash
   flutter pub get
   ```

4. **Configurer Firebase** :
   - Le projet utilise une variable d'environnement pour la clé API Firebase afin de sécuriser les accès.
   - Configurez votre projet via `flutterfire configure` ou assurez-vous que `lib/firebase_options.dart` est présent.

5. **Lancer l'application** :
   Pour lancer l'application, vous devez fournir votre clé API Firebase via `--dart-define` :
   ```bash
   flutter run --dart-define=FIREBASE_API_KEY=VOTRE_CLE_API_ICI
   ```

## 📝 Auteur

- **Rémy Mazingue** (RemyMz)

---
*Projet réalisé à des fins pédagogiques - IMT Nord Europe*
