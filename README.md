# 👨‍🌾 Cht'i Face Bouc - Rendu Final

**Cht'i Face Bouc** est une application sociale hyper-locale développée avec **Flutter** et **Firebase**, spécialement conçue pour les habitants des Hauts-de-France. Ce projet allie les fonctionnalités classiques d'un réseau social à l'identité culturelle forte du Nord.

---

## 🌟 Points Forts & Identité Locale
L'application se distingue par l'intégration d'expressions picardes et une ambiance conviviale :
- **"Vindidi !"** : Pour aimer une publication.
- **"Eun' tiote rincette"** : Pour rafraîchir le contenu.
- **"Biloute"** : L'accueil chaleureux réservé à chaque utilisateur.

## 🚀 Fonctionnalités Implémentées

- **🔐 Authentification** : Système complet de création de compte et de connexion sécurisée (Firebase Auth).
- **👤 Profil Personnalisé** : Chaque membre peut définir sa photo de profil, sa photo de couverture et sa description.
- **📰 Fil d'Actualité** : Consultation des publications de la communauté en temps réel avec gestion du scroll infini.
- **📸 Partage de Contenu** : Publication de textes et d'images capturées via l'appareil photo ou la galerie.
- **💬 Interactions Sociales** : Système de "Likes" et de commentaires en cascade sur chaque publication.
- **👥 Annuaire des Membres** : Liste complète des inscrits pour favoriser la connexion entre voisins.
- **🔔 Notifications Internes** : Suivi en temps réel des interactions sur ses propres publications.

## 🛠️ Stack Technique

- **Framework** : [Flutter](https://flutter.dev/) (Dart)
- **Backend (Firebase)** :
  - **Firestore** : Base de données NoSQL pour la synchronisation temps réel.
  - **Authentication** : Gestion sécurisée des sessions utilisateurs.
  - **Cloud Storage** : Stockage persistant des images de profil et des posts.
- **Architecture** : Pattern Service-Model-Widget pour une séparation nette de la logique métier et de l'interface.

## 📦 Installation et Lancement

### 1. Configuration Firebase
L'application nécessite un projet Firebase actif. Pour l'installer :
1. Créez un projet sur la [Console Firebase](https://console.firebase.google.com/).
2. Activez **Auth** (Email/Pass), **Firestore** et **Storage**.
3. Liez votre application via `flutterfire configure`.

### 2. Lancement
```bash
flutter pub get
flutter run
```

---
**Développé par :** Rémy Mazingue (IMT Nord Europe)  
**Version :** 1.0 (Rendu Final - Mai 2026)
