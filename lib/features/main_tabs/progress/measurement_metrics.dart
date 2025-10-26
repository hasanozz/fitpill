import 'package:flutter/material.dart';

import 'package:fitpill/generated/l10n/l10n.dart';

const List<String> metrics = [
  bodyFatMetricKey,
  ffmiMetricKey,
  bmiMetricKey,
  leanMassMetricKey,
  "weight",
  "arm",
  "waist",
  "neck",
  "hip",
  "shoulder",
  "chest",
  "leg",
  "calf",
];

const String bodyFatMetricKey = 'bodyFat';
const String leanMassMetricKey = 'leanMass';
const String ffmiMetricKey = 'ffmi';
const String bmiMetricKey = 'bmi';

const Set<String> autoTrackedMetrics = {
  bodyFatMetricKey,
  leanMassMetricKey,
  ffmiMetricKey,
  bmiMetricKey,
};

String getMetricName(BuildContext context, String metric) {
  switch (metric) {
    case bodyFatMetricKey:
      return S.of(context)!.bodyFatPercentage;
    case leanMassMetricKey:
      return S.of(context)!.leanMass;
    case ffmiMetricKey:
      return S.of(context)!.ffmi;
    case bmiMetricKey:
      return S.of(context)!.bmi;
    case "weight":
      return S.of(context)!.weight;
    case "arm":
      return S.of(context)!.arm;
    case "waist":
      return S.of(context)!.waist;
    case "neck":
      return S.of(context)!.neck;
    case "hip":
      return S.of(context)!.hip;
    case "shoulder":
      return S.of(context)!.shoulder;
    case "chest":
      return S.of(context)!.chest;
    case "leg":
      return S.of(context)!.leg;
    case "calf":
      return S.of(context)!.calf;
    default:
      return S.of(context)!.metrics;
  }
}

// Metriklere özel ikonlar
IconData getMetricIcon(String metric) {
  switch (metric) {
    case "weight":
      return Icons.monitor_weight_rounded;
    case bodyFatMetricKey:
      return Icons.percent_outlined;
    case leanMassMetricKey:
      return Icons.fitness_center_outlined;
    case ffmiMetricKey:
      return Icons.speed_rounded;
    case bmiMetricKey:
      return Icons.monitor_weight_outlined;
    default:
      return Icons.straighten_rounded;
  }
}

// Metrik birimleri
String getMetricUnit(String metric) {
  switch (metric) {
    case "weight":
      return "kg";
    case bodyFatMetricKey:
      return "%";
    case leanMassMetricKey:
      return "kg";
    case ffmiMetricKey:
      return "kg/m²";
    case bmiMetricKey:
      return "kg/m²";
    default:
      return "cm";
  }
}

String formatMetricValue(String metric, double value) {
  final String unit = getMetricUnit(metric);
  final double roundedValue = (value * 10).roundToDouble() / 10;
  final bool isWholeNumber =
      roundedValue == roundedValue.roundToDouble();

  final String displayValue = isWholeNumber
      ? roundedValue.toStringAsFixed(0)
      : roundedValue.toStringAsFixed(1);

  return "$displayValue $unit";
}
