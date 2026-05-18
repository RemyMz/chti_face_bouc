/// Clés utilisées pour les collections et les documents dans Firestore.
/// Centralise les chaînes de caractères pour éviter les erreurs de frappe.

// Collections
/// Nom de la collection des membres.
String memberCollectionKey = "members";
/// Nom de la collection des publications.
String postCollectionKey = "posts";
/// Nom de la collection des commentaires.
String commentCollectionKey = "comments";
/// Nom de la collection des notifications.
String notificationCollectionKey = "notifications";

// Member
/// Clé pour l'identifiant du membre.
String memberIdKey = "memberId";
/// Clé pour le nom.
String nameKey = "name";
/// Clé pour le prénom.
String surnameKey = "surname";
/// Clé pour l'image de profil.
String profilePictureKey = "profilePicture";
/// Clé pour l'image de couverture.
String coverPictureKey = "coverPicture";
/// Clé pour la description/biographie.
String descriptionKey = "description";

// Post
/// Clé pour le texte de la publication.
String textKey = "text";
/// Clé pour l'image de la publication.
String postImageKey = "image";
/// Clé pour la date.
String dateKey = "date";
/// Clé pour la localisation (ville/lieu).
String locationKey = "location";
/// Clé pour la liste des likes.
String likesKey = "likes";

// Notif
/// Clé pour l'expéditeur de la notification.
String fromKey = "from";
/// Clé pour l'état de lecture de la notification.
String isReadKey = "read";
/// Clé pour l'identifiant du post lié à la notification.
String postIdKey = "postID";
