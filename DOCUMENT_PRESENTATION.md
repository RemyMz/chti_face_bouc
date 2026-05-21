# Présentation du Projet : Cht'i Face Bouc

**Auteur :** MAZINGUE Rémy  
**Module :** Développement Mobile (Dart & Flutter)  
**Date :** Mai 2026  

## 1. Plateforme de travail
- **Système d'exploitation :** macOS Ventura (Version 13.7.8)
- **Version Flutter :** 3.38.10
- **Version Dart :** 3.10.9
- **IDE :** VS Code
- **Environnement de test :** Google Chrome

## 2. Descriptif de l'application
Cht'i Face Bouc est une application sociale hyper-locale dédiée aux habitants des Hauts-de-France. Elle allie les fonctionnalités classiques d'un réseau social à une identité visuelle et textuelle ancrée dans la culture du Nord.

### Fonctionnalités implémentées :
- **Authentification sécurisée :** Inscription et connexion via Firebase Auth.
- **Gestion du Profil :** Personnalisation de l'avatar et de la photo de couverture (via Firebase Storage).
- **Fil d'actualité :** Affichage des publications de tous les membres en temps réel.
- **Interactions sociales :** Système de "Likes" (*Vindidi !*) et de commentaires.
- **Notifications :** Système de notifications internes pour les interactions sur les posts.
- **Liste des membres :** Consultation de l'annuaire des utilisateurs inscrits.

## 3. Choix techniques
- **Architecture :** Séparation stricte entre les modèles de données, les services Firebase et les widgets d'interface pour une meilleure maintenabilité.
- **Design :** Utilisation du "Glassmorphism" et d'un thème moderne respectant l'identité visuelle demandée.
- **Temps Réel :** Utilisation intensive des `Streams` de Firestore pour une mise à jour instantanée de l'interface sans rechargement manuel.

## 4. Difficultés rencontrées et solutions
- **Gestion des images :** L'upload asynchrone et la mise à jour immédiate de l'interface ont nécessité une gestion rigoureuse des états de chargement.
- **Index Firestore :** La mise en place du tri par date sur des requêtes filtrées a nécessité la création d'index composites sur la console Firebase.

## 5. Captures d'écran