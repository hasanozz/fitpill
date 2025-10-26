import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

///************************************************
// DOUBLE'DAN STRINGE ÇEVİRME
String formatDoubleFromString(String? value) {
  if (value == null || value.trim().isEmpty) return '';

  final parsed = double.tryParse(value.replaceAll(',', '.'));
  if (parsed == null) return value;

  if (parsed == parsed.toInt()) {
    return parsed.toInt().toString();
  } else {
    return parsed.toStringAsFixed(1);
  }
}
///************************************************



///************************************************
// TEXTİN İLK HARFİNİ BÜYÜK YAPIYORRRR
String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
///************************************************



///************************************************
// VİRGÜLÜ NOKTA YAP
class CustomDecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(',', '.');

    final regex = RegExp(r'^\d{1,4}([.]\d{0,2})?$');

    if (newText.isEmpty || regex.hasMatch(newText)) {
      return newValue.copyWith(text: newText); // izin ver
    } else {
      return oldValue; // geçersiz → eskiyi koru
    }
  }
}
///************************************************



///************************************************
// tarihi 17 Şub 2003 gibi falan çeviriyor
String formatDate(DateTime date, BuildContext context) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat('d MMM yyy', locale).format(date);
}
