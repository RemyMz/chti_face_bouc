import 'package:intl/intl.dart';

class FormatageDate {
  String formatted(int timeStamp) {
    DateTime postTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    DateTime now = DateTime.now();
    DateFormat format;

    if (now.difference(postTime).inDays > 0) {
      // Si le post date de plus d'un jour, on affiche la date complète
      format = DateFormat.yMMMd();
    } else {
      // Sinon on affiche l'heure
      format = DateFormat.Hm();
    }
    
    return format.format(postTime).toString();
  }
}
