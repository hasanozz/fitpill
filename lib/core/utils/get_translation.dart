// lib/core/utils/app_helpers.dart

import 'package:flutter/material.dart';
import 'package:fitpill/generated/l10n/l10n.dart'; // S sınıfı

// Bu fonksiyon, UI katmanında çeviri anahtarını (key) kullanarak çevrilmiş metni döndürür.
String getTranslate(BuildContext context, String key) {
  final S? s = S.of(context);

  // 1. Çeviri fonksiyonlarını bir Map içinde eşleştiriyoruz.
  // Not: Bu Map, S.of(context) her çağrıldığında yeniden oluşturulacak.
  // Performans için kabul edilebilir bir maliyettir.
  final Map<String, String Function()> translationMap = {
    // BMI Sonuçları
    'severelyUnderweight': () => s!.severelyUnderweight,
    'underweight': () => s!.underweight,
    'idealWeight': () => s!.idealWeight,
    'overweight': () => s!.overweight,
    'obese': () => s!.obese,



  };

  // 2. Anahtarı Map'ten bul ve fonksiyonu çağırıp değeri döndür.
  final translator = translationMap[key];

  if (translator != null) {
    return translator(); // Çeviri metodunu çağır (örneğin s.obese())
  }

  // 3. Bulunamazsa anahtarın kendisini döndür (Hata tespiti için iyi).
  return key;
}