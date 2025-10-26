import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildInputField({
  required BuildContext context,
  required TextEditingController controller,
  required String labelText,
  required IconData icon,
  required String suffixText,
  required void Function(String)? onChanged, // dışarıdan alınan
}) {
  final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  final textColor = isDarkTheme ? Colors.white54 : Colors.black87;
  final cardColor = isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white;

  return Container(
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3)),
      ],
    ),
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      cursorColor: ThemeHelper.getFitPillColor(context),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*'))
      ],
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: ThemeHelper.getFitPillColor(context)),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        suffix: Text(
          suffixText,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        filled: true,
        fillColor: cardColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
              color: ThemeHelper.getFitPillColor(context), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: textColor, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      onChanged: onChanged, // burada çağırılıyor
    ),
  );
}
