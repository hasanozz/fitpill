// lib/core/system/config/theme/theme_providers.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_repository.dart';

final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return ThemeRepository();
});

// 1. TEMA DEĞİŞTİRME MANTIĞI (Notifier)
class ThemeNotifier extends Notifier<ThemeMode> {
  // Notifier state'i artık sadece ThemeMode'u tutar.
  // Yükleme (Hydration) işi buradan çıkar.

  @override
  ThemeMode build() {
    // Uygulama başlangıç teması (Yükleme bitince bu değer güncellenecek)
    return ThemeMode.system;
  }

  // initState mantığını set ederek simüle ediyoruz
  // Bu metot, sadece themeInitializationProvider bittiğinde çağrılacak.
  void setInitialTheme(ThemeMode mode) {
    state = mode;
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await ref.read(themeRepositoryProvider).save(mode);
  }

  Future<void> toggleTheme() async {
    final next = (state == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    await setTheme(next);
  }
}

final themeNotifierProvider =
NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);


// 2. TEMA YÜKLEME MANTIĞI (FutureProvider)
final themeInitializationProvider = FutureProvider<void>((ref) async {
  // Repo'dan başlangıç değerini asenkron olarak çek.
  final repo = ref.read(themeRepositoryProvider);
  final initialMode = await repo.load();

  // Yüklenen modu ThemeNotifier'a aktar ve Notifier'ı başlat.
  // Bu, UI'da themeNotifierProvider'ı izleyen herkesin güncellemesini tetikler.
  ref.read(themeNotifierProvider.notifier).setInitialTheme(initialMode);

  // Yükleme başarılı, FutureProvider 'void' döner.
});