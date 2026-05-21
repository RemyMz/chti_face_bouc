# Présentation du Projet : Cht'i Face Bouc

**Auteur :** MAZINGUE Rémy  
**Module :** Développement Mobile (Dart & Flutter)  
**Date :** Mai 2026  

## 1. Plateforme de travail
- **Système d'exploitation :** macOS Ventura (Version 13.7.8)
- **Version Flutter :** 3.38.10
- **Version Dart :** 3.10.9
- **IDE :** VS Code
- **Environnement de test :** Google Chrome & Android/iOS

## 2. Descriptif de l'application
Cht'i Face Bouc est une application sociale hyper-locale dédiée aux habitants des Hauts-de-France. Elle allie les fonctionnalités classiques d'un réseau social à une identité visuelle et textuelle ancrée dans la culture du Nord.

### Fonctionnalités implémentées :
- **Authentification sécurisée :** Inscription et connexion avec messages personnalisés en Chti.
- **Gestion du Profil :** Personnalisation complète (Avatar, Couverture, Description).
- **Fil d'actualité :** Flux temps réel optimisé pour la fluidité.
- **Interactions sociales :** Système de "Likes" (*Vindidi !*) et de commentaires.
- **Notifications :** Système interactif permettant de cliquer sur une notification pour accéder directement au post concerné.
- **Liste des membres :** Annuaire complet des utilisateurs.

## 3. Choix techniques & Optimisations
- **Architecture :** Séparation stricte (Services / Modèles / Widgets).
- **Performance :** 
  - Passage en **singleton** pour le service Firestore afin d'optimiser l'utilisation de l'instance Firebase.
  - Optimisation des listes (Posts et Notifications) en remplaçant les écoutes temps réel des profils membres par des récupérations ponctuelles (`FutureBuilder`), supprimant ainsi tout lag lors du scroll.
- **Expérience Utilisateur :** Mise en place d'un état de chargement lors de la publication d'un post pour éviter les envois multiples (double-posting).

## 4. Difficultés rencontrées et solutions
- **Double-posting :** Résolu par l'ajout d'un booléen d'état bloquant l'UI pendant l'upload.
- **Lenteur de l'interface :** Identifiée comme provenant de la multiplication des Streams. Résolue par une stratégie hybride Stream (pour les listes) / Future (pour les détails membres).
- **Navigation Notifications :** Implémentation d'une récupération dynamique du post via son ID stocké dans la notification pour permettre un accès direct au contenu.

## 5. Captures d'écran (Mises à jour)

| Connexion (Identité locale) | Accueil (Optimisé) |
| :---: | :---: |
| ![Connexion](captures/ecran_connexion.png) | ![Accueil](captures/ecran_accueil.png) |

*(Les captures reflètent la structure et les fonctionnalités finales de l'application)*
