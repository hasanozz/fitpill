import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> showCustomDatePicker(
    {required BuildContext context,
    required String initialDate,
    required firstDate,
    required lastDate // yyyy-MM-dd format bekleniyor
    }) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.tryParse(initialDate) ?? DateTime.now(),
    firstDate: DateTime(firstDate),
    lastDate: DateTime(lastDate),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogTheme: DialogThemeData(
            backgroundColor: ThemeHelper.getCardColor(context),
          ),
          colorScheme: ThemeHelper.isDarkTheme(context)
              ? const ColorScheme.dark(
                  primary: Colors.orange,
                  onPrimary: Colors.black,
                  onSurface: Colors.white70,
                )
              : const ColorScheme.light(
                  primary: Color(0xFF0D47A1),
                  onPrimary: Colors.white,
                  onSurface: Colors.black87,
                ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: ThemeHelper.getTextColor(context),
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    return DateFormat('yyyy-MM-dd').format(picked);
  }
  return null;
}
