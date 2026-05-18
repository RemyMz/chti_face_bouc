import 'package:flutter/material.dart';

/// Classe utilitaire définissant le style visuel commun des champs de texte (InputDecoration).
class StyleChampTexte {
  /// Retourne une décoration de champ de texte harmonisée pour l'application.
  /// [label] : Le texte d'étiquette.
  /// [icon] : L'icône optionnelle à afficher au début du champ.
  static InputDecoration decoration({required String label, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: Colors.brown) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.brown, width: 2),
      ),
    );
  }
}
