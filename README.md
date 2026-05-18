# Chti Face Bouc 👨‍🌾💻 - Édition Premium

**Chti Face Bouc** est une application sociale moderne et fluide développée avec **Flutter** et **Firebase**. Conçue à l'origine pour connecter la communauté locale, elle a évolué vers une expérience utilisateur premium alliant esthétique léchée et fonctionnalités robustes.

## ✨ Nouvelles Fonctionnalités & Améliorations (v2.0)

L'application a été entièrement refondue pour offrir une expérience haut de gamme :

- **🎨 Design Moderne & Polie** : Interface basée sur Material 3 avec des bordures ultra-arrondies, des ombres douces et une typographie soignée.
- **✨ Effets Visuels Premium** :
  - **Glassmorphism** : Barres de navigation et d'en-tête translucides avec effet de flou (frosted glass).
  - **Animations Hero** : Transitions fluides des avatars d'un écran à l'autre.
  - **SliverAppBar** : En-tête de profil dynamique avec effet parallaxe et dégradés protecteurs.
  - **Shimmer Loading** : Remplacement des spinners par des squelettes de chargement scintillants.
- **🌙 Mode Sombre Intégral** : Support automatique du thème système (Clair/Sombre) avec une palette de couleurs optimisée.
- **📍 Géolocalisation Précise** : Détection automatique de la ville avec gestion intelligente des erreurs et repli sur coordonnées GPS.
- **📝 Gestion Complète des Posts** : Possibilité de **modifier** et **supprimer** ses propres publications (incluant le nettoyage des images dans le Cloud Storage).
- **💬 Interactions Sociales** : Système de likes ("Vindidi !") et commentaires en temps réel avec notifications intégrées.

## 🛠️ Stack Technique

- **Framework** : [Flutter](https://flutter.dev/) (Dart)
- **Backend** : [Firebase](https://firebase.google.com/) (Auth, Firestore, Storage)
- **Packages Clés** :
  - `shimmer` (Effets de chargement)
  - `geolocator` & `geocoding` (Localisation)
  - `image_picker` (Gestion multimédia)
  - `firebase_ui_auth` (Authentification)

## 📦 Installation et Lancement

1. **Prérequis** :
   - Flutter SDK (^3.10.9)
   - Un projet Firebase configuré

2. **Installation** :
   ```bash
   git clone https://github.com/RemyMz/chti_face_bouc.git
   cd chti_face_bouc
   git checkout improvements
   flutter pub get
   ```

3. **Lancement** :
   ```bash
   flutter run --dart-define=FIREBASE_API_KEY=VOTRE_CLE_API
   ```

## 📝 Auteur

- **Rémy Mazingue** (RemyMz)

---
*Projet réalisé à des fins pédagogiques - IMT Nord Europe - 2026*
