// lib/utils/progress_functions.dart

import 'package:flutter/material.dart';

import 'package:fitpill/generated/l10n/l10n.dart';

String? validateInput(String input, String metric, BuildContext context) {
  if (input.isEmpty) {
    return S.of(context)!.enterValidNumber;
  }

  final regex = RegExp(r'^\d*\.?\d*$');
  if (!regex.hasMatch(input)) {
    return S.of(context)!.onlyNumericValuesAllowed;
  }

  final double? value = double.tryParse(input);
  if (value == null) {
    return S.of(context)!.invalidNumberFormat;
  }

  switch (metric) {
    case "weight":
      if (value < 30 || value > 250) return S.of(context)!.invalidWeight;
      break;
    case "arm":
    case "neck":
      if (value < 10 || value > 100) return S.of(context)!.measurementRange;
      break;
    case "shoulder":
    case "chest":
    case "waist":
    case "hip":
    case "leg":
    case "calf":
      if (value < 10 || value > 200) return S.of(context)!.measurementRange;
      break;
  }

  return null;
}
