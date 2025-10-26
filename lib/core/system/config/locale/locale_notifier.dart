// lib/core/system/config/locale/locale_providers.dart (Yeni adıyla)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpill/generated/l10n/l10n.dart';
import 'locale_repository.dart';
import 'locale_keys.dart'; // Bu dosyanın da Core/Utils/Constants altına taşındığını varsayıyoruz.

class StringsNotifier extends Notifier<S?> {
  @override
  S? build() => null;

  // S nesnesini main.dart'tan set etmek için metot
  void setStrings(S strings) {
    // Yalnızca yeni bir çeviri nesnesi geldiğinde state'i değiştiriyoruz.
    if (state != strings) {
      state = strings;
    }
  }
}

// Global olarak erişilebilecek NotifierProvider tanımı.
final currentStringsProvider = NotifierProvider<StringsNotifier, S?>(StringsNotifier.new);



final localeRepositoryProvider = Provider<LocaleRepository>((ref) {
  return LocaleRepository();
});

// 1. DİL DEĞİŞTİRME MANTIĞI (Notifier)
class LocalizationNotifier extends Notifier<Locale> {
  // Notifier'ın varsayılan state'i. Yükleme bitene kadar bu kalır.
  @override
  Locale build() {
    return const Locale('tr');
  }

  // YÜKLEME SONUNDA SADECE BİR KEZ ÇAĞRILACAK METOT
  void setInitialLocale(Locale mode) {
    // state'i, FutureProvider'ın yüklediği değerle günceller.
    state = mode;
  }

  // KULLANICININ ÇAĞIRDIĞI METOT
  void setLocale(Locale locale) {
    if (!LocaleKeys.supported.contains(locale.languageCode)) return;
    state = locale;
    unawaited(ref.read(localeRepositoryProvider).saveLocale(locale));
  }

  void setTurkish() => setLocale(const Locale('tr'));
  void setEnglish() => setLocale(const Locale('en'));
}

final localizationProvider =
NotifierProvider<LocalizationNotifier, Locale>(LocalizationNotifier.new);


// 2. DİL YÜKLEME MANTIĞI (FutureProvider)
final localeInitializationProvider = FutureProvider<void>((ref) async {
  // Repodan başlangıç değerini çek.
  final repo = ref.read(localeRepositoryProvider);
  final savedLocale = await repo.loadLocale();

  // Yükleme sırasında varsayılan dil mantığı
  final systemCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  final defaultLocale = LocaleKeys.supported.contains(systemCode)
      ? Locale(systemCode)
      : const Locale('tr');

  final initialLocale = savedLocale ?? defaultLocale;

  // KRİTİK: Yüklenen değeri Notifier'a aktar.
  ref.read(localizationProvider.notifier).setInitialLocale(initialLocale);

  // Firebase ve diğer servisler için burada S.delegate.load(initialLocale) da çağrılabilir.
});