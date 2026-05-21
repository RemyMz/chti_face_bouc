# 👨‍🌾 Cht'i Face Bouc - Rendu Final

**Cht'i Face Bouc** est une application sociale hyper-locale développée avec **Flutter** et **Firebase**, spécialement conçue pour les habitants des Hauts-de-France. Ce projet allie les fonctionnalités classiques d'un réseau social à l'identité culturelle forte du Nord.

---

## 🌟 Points Forts & Identité Locale
L'application se distingue par l'intégration d'expressions picardes et une ambiance conviviale :
- **"Vindidi !"** : Pour aimer une publication.
- **"Eun' tiote rincette"** : Pour rafraîchir le contenu (bouton dans la barre du haut).
- **"T'in pour commincher"** : Accueil chaleureux sur la page d'authentification.
- **"Quoi de neuf, biloute ?"** : L'invitation à partager son humeur.

## 🚀 Fonctionnalités Implémentées

- **🔐 Authentification** : Système complet de création de compte et de connexion sécurisée (Firebase Auth).
- **👤 Profil Personnalisé** : Chaque membre peut définir sa photo de profil, sa photo de couverture et sa description.
- **📰 Fil d'Actualité** : Consultation des publications de la communauté en temps réel.
- **📸 Partage de Contenu** : Publication de textes et d'images avec **système anti-doublon** (chargement visuel pendant l'envoi).
- **💬 Interactions Sociales** : Système de "Likes" et de commentaires en cascade.
- **👥 Annuaire des Membres** : Liste complète des inscrits pour favoriser la connexion entre voisins.
- **🔔 Notifications Intelligentes** : Suivi des interactions avec **navigation directe** vers le post concerné.

## 🛠️ Stack Technique & Optimisations

- **Framework** : [Flutter](https://flutter.dev/) (Dart)
- **Backend (Firebase)** : Firestore, Authentication, Cloud Storage.
- **Optimisations de Performance** : 
  - Utilisation du pattern **Singleton** pour les services Firebase.
  - Bascule sur des `FutureBuilder` pour les données membres dans les listes afin d'éliminer le lag et réduire la consommation de données.
- **Architecture** : Pattern Service-Model-Widget.

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
**Version :** 1.1 (Optimisé - Mai 2026)
