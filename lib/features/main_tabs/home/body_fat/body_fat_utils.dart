import 'dart:math' as math;

class BodyFatUtils {
  const BodyFatUtils._();

  static double? calculateBodyFatPercentage({
    required String gender,
    required double waist,
    required double neck,
    double? hip,
    required double height,
  }) {
    final normalizedGender = gender.toLowerCase();
    if (height <= 0 || waist <= 0 || neck <= 0) {
      return null;
    }

    if (normalizedGender == 'male') {
      if (waist <= neck) {
        return null;
      }
      return _calculateMaleBodyFat(waist, neck, height);
    }

    if (normalizedGender == 'female') {
      if (hip == null || hip <= 0 || waist + hip <= neck) {
        return null;
      }
      return _calculateFemaleBodyFat(waist, neck, hip, height);
    }

    return null;
  }

  static double normalizeBodyFat(double value) {
    return value.clamp(0, 70).toDouble();
  }

  static double calculateLeanMass({
    required double weight,
    required double bodyFatPercentage,
  }) {
    final safePercentage = bodyFatPercentage.clamp(0, 100).toDouble();
    return weight * (1 - safePercentage / 100);
  }

  static double? calculateBmi({
    required double weight,
    required double heightCm,
  }) {
    if (weight <= 0 || heightCm <= 0) {
      return null;
    }

    final heightMeters = heightCm / 100;
    if (heightMeters <= 0) {
      return null;
    }

    final bmi = weight / math.pow(heightMeters, 2);
    if (!bmi.isFinite || bmi.isNaN) {
      return null;
    }

    return bmi.clamp(0, 80).toDouble();
  }

  static double? calculateFfmi({
    required double leanMassKg,
    required double heightCm,
  }) {
    if (leanMassKg <= 0 || heightCm <= 0) {
      return null;
    }

    final heightMeters = heightCm / 100;
    if (heightMeters <= 0) {
      return null;
    }

    final ffmi = leanMassKg / math.pow(heightMeters, 2);
    if (!ffmi.isFinite || ffmi.isNaN) {
      return null;
    }

    return ffmi.clamp(0, 80).toDouble();
  }

  static double _calculateMaleBodyFat(
    double waist,
    double neck,
    double height,
  ) {
    const numerator = 495;
    final denominator = 1.0324 -
        0.19077 * _log10(waist - neck) +
        0.15456 * _log10(height);
    return numerator / denominator - 450;
  }

  static double _calculateFemaleBodyFat(
    double waist,
    double neck,
    double hip,
    double height,
  ) {
    const numerator = 495;
    final denominator = 1.29579 -
        0.35004 * _log10(waist + hip - neck) +
        0.221 * _log10(height);
    return numerator / denominator - 450;
  }

  static double _log10(double value) => math.log(value) / math.ln10;
}
