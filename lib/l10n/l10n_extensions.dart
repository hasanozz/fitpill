// lib/extensions/l10n_extensions.dart

// Bu dosyaya sadece AppLocalizations sınıfını import etmeniz yeterli
import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:intl/intl.dart'; // Intl.message kullanmak için gerekli

extension ActivityLocalizationExtension on S {

  // Aktivite isim çevirisi için
  String getActivityName(String key) {
    // Burada Intl.message kullanıyoruz, böylece bu çeviriler ARB dosyalarına bağlı kalmaz.
    // Ancak her çeviri değişikliğinde bu dosyanın güncellenmesi gerekir.
    switch (key) {
      case 'walk':
        return Intl.message(
          'Walk',
          name: 'walk', // Bu isim unique olmalıdır
          desc: 'Activity name for walking',
          args: [],
        );
      case 'run':
        return Intl.message(
          'Run',
          name: 'run',
          desc: 'Activity name for running',
          args: [],
        );
    // Diğer caseleri buraya ekleyin...
      case 'bicycle':
        return Intl.message(
          'Bicycle',
          name: 'bicycle_activity',
          desc: 'Activity name for cycling',
          args: [],
        );
      case 'weightlifting':
        return Intl.message(
          'Weightlifting',
          name: 'weightlifting_activity',
          desc: 'Activity name for weightlifting',
          args: [],
        );
      default:
        return key;
    }
  }

  // 2. Tempo Çevirisi için
  // getTempoName metodu, 'low', 'medium', 'high' anahtarlarını çevirir.
  String getTempoName(String key) {
    switch (key) {
      case 'low':
        return Intl.message(
          'Low',
          name: 'tempo_low', // Unique isim
          desc: 'Low tempo/intensity',
          args: [],
        );
      case 'medium':
        return Intl.message(
          'Medium',
          name: 'tempo_medium', // Unique isim
          desc: 'Medium tempo/intensity',
          args: [],
        );
      case 'high':
        return Intl.message(
          'High',
          name: 'tempo_high', // Unique isim
          desc: 'High tempo/intensity',
          args: [],
        );
      default:
        return key;
    }
  }

  // 3. Genel Çeviri için (Malzemeler vb.)
  // getTranslation metodu, ARB dosyalarında tanımlı olan metotları kullanır.
  String getTranslation(String key) {
    // Burada, Intl.message yerine S sınıfında generated metotları kullanırız.
    // **Bu kodun çalışması için bu kelimelerin ARB dosyalarına eklenmiş olması GEREKİR.**
    switch (key) {
      case 'towel':
      // towel: ARB dosyasında towel adıyla bir giriş olmalı
        return towel;
      case 'water_bottle':
      // water_bottle: ARB dosyasında water_bottle adıyla bir giriş olmalı
        return waterBottle;
      case 'sports_shoes':
        return sportsShoes;
      case 'protein_bar':
        return proteinBar;
      case 'gloves':
        return gloves;
      case 'headphones':
        return headphones;
      default:
        return key; // Bilinmeyenler orijinal göster
    }}

}