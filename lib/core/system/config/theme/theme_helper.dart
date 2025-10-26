import 'package:flutter/material.dart';

class ThemeHelper {
  /// Dark Mode açık mı? Direkt boolean değer döndürür.
  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Arka plan rengi (Dark Mode'a göre belirlenir).
  static Color getBackgroundColor(BuildContext context) {
    return isDarkTheme(context) ? const Color(0xFF181818) : Colors.white;
  }

  /// Kart rengi (Dark Mode'a göre belirlenir).
  static Color getCardColor(BuildContext context) {
    return isDarkTheme(context)
        ? const Color(0xFF1F1F1F)
        : const Color(0xFFF4F4F4);
  }

  static Color getCardColor1(BuildContext context) {
    return isDarkTheme(context)
        ? Colors.black26
        : const Color(0xFFF4F4F4);
  }

  /// Yazı rengi (Dark Mode'a göre belirlenir).
  static Color getTextColor(BuildContext context) {
    return isDarkTheme(context)
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF1A1A1A);
  }

  static Color getFitPillColor(BuildContext context) {
    return isDarkTheme(context)
        ? const Color(0xFFFFA726)
        : const Color(0xFF0D47A1);
  }

  static Color getCardColor2(BuildContext context) {
    return isDarkTheme(context)
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF4F4F4);
  }
}