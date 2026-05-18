import 'package:intl/intl.dart';

/// Classe utilitaire pour le formatage des dates au sein de l'application.
class FormatageDate {
  /// Retourne une chaîne de caractères formatée à partir d'un [timeStamp].
  /// Affiche l'heure si la date est d'aujourd'hui, sinon affiche la date complète.
  String formatted(int timeStamp) {
    DateTime postTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    DateTime now = DateTime.now();
    DateFormat format;

    if (now.difference(postTime).inDays > 0) {
      // Affichage : 12 déc. 2023
      format = DateFormat.yMMMd();
    } else {
      // Affichage : 14:30
      format = DateFormat.Hm();
    }
    
    return format.format(postTime).toString();
  }
}
