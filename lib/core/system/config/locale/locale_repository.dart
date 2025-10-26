import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_keys.dart';

class LocaleRepository {
  Future<Locale?> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(LocaleKeys.storageKey);
    if (code == null) return null;
    if (!LocaleKeys.supported.contains(code)) return null;
    return Locale(code);
  }

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LocaleKeys.storageKey, locale.languageCode);
  }
}
