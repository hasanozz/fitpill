// lib/provider/progress_provider.dart
// Riverpod 3.x (3.0.3) uyumlu sürüm
// Neden bu değişiklik? (Why)
// - StateNotifier yerine AsyncNotifier kullanarak AsyncValue yaşam döngüsünü
//   (loading/error/data) first-class destekliyoruz.
// - "ref" doğrudan AsyncNotifier içinde mevcut; ekstra _ref taşımaya gerek yok.
// - Repositories (ProgressRepository / ProgressGoalsRepository) build() içinde
//   güvenli şekilde (userId ile) initialize ediliyor.

// ------------------ Imports ------------------
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:fitpill/core/models/chartData_model.dart';
import 'package:fitpill/features/main_tabs/home/body_fat/body_fat_utils.dart';
import 'package:fitpill/features/main_tabs/progress/measurement_metrics.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';
import 'package:fitpill/features/main_tabs/home/badge/badge_provider.dart';
import 'package:fitpill/features/main_tabs/progress/progress_model.dart';
import 'package:fitpill/features/auth/auth_provider.dart';

import 'progress_repository.dart';
import 'progress_goals_repository.dart';
import 'progress_goals_provider.dart';

// ------------------ Provider: Controller ------------------
// Eski: StateNotifierProvider<ProgressNotifier, AsyncValue<void>>
// Yeni: AsyncNotifierProvider<ProgressNotifier, void>
final progressProvider =
AsyncNotifierProvider<ProgressNotifier, void>(ProgressNotifier.new);

// ------------------ Controller ------------------
class ProgressNotifier extends AsyncNotifier<void> {
  // Repos: build() içinde userId ile init edilecek
  late final ProgressRepository _repository;
  late final ProgressGoalsRepository _goalsRepository;

  // Bu controller bir "veri tutmaz"; yalnızca komut (save/delete) çalıştırır.
  // Bu yüzden build() null (void) döndürür ve sadece init işleri yapar.
  @override
  Future<void> build() async {
    // Not: userIdProvider senin auth yapına göre String? olabilir.
    // Bu controller, giriş yapılmış olduğu senaryoda kullanılır.
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      // Kullanıcı yoksa state'i hata yapıp çıkıyoruz (defansif).
      state = AsyncError(StateError('User is not signed in.'), StackTrace.current);
      return;
    }

    _repository = ProgressRepository(userId: userId);
    _goalsRepository = ProgressGoalsRepository(userId: userId);

    // İlk state: hazır (data: null)
    state = const AsyncData(null);
  }

  // ------------------ Public Commands ------------------

  // Progress kaydet (save)
  Future<void> save(String metric, double value) async {
    // Premium kontrolü (provider state → bool?)
    final premiumStatus = ref.read(premiumStatusProvider);
    final bool? hasPremium = premiumStatus.maybeWhen(
      data: (v) => v,
      orElse: () => null,
    );

    if (hasPremium == null) {
      // Premium state henüz gelmediyse: loading göster ve çık
      state = const AsyncLoading();
      return;
    }

    if (!hasPremium) {
      state = AsyncError(
        StateError('Premium membership required to save progress.'),
        StackTrace.current,
      );
      return;
    }

    // Asıl iş: ölçümü kaydet + türev metrikleri güncelle
    state = const AsyncLoading();
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await _repository.saveMeasurement(metric, value, today);

      await _goalsRepository.evaluateGoalsForMetric(
        metric: metric,
        newValue: value,
      );

      await _updateDerivedMetrics(
        metric: metric,
        date: today,
        value: value,
      );

      // Türev sağlayıcıları invalidation
      ref.invalidate(progressGoalsProvider);
      ref.invalidate(badgeProvider);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Progress sil (delete)
  Future<void> delete(String metric, String date) async {
    state = const AsyncLoading();
    try {
      await _repository.deleteMeasurement(metric, date);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // ------------------ Internal: Derived Metrics ------------------

  static const _bodyCompositionInputs = {'waist', 'neck', 'hip', 'weight'};

  Future<void> _updateDerivedMetrics({
    required String metric,
    required String date,
    required double value,
  }) async {
    // Profil verisi (boy/gender) lazım
    final profileState = ref.read(profileProvider);
    final profile = profileState.value;
    if (profile == null) return;

    final heightValue = double.tryParse(
      profile.height.trim().replaceAll(',', '.'),
    );

    var derivedMetricSaved = false;

    // 1) BMI
    if (metric == 'weight' && heightValue != null && heightValue > 0) {
      final bmi = BodyFatUtils.calculateBmi(
        weight: value,
        heightCm: heightValue,
      );
      if (bmi != null) {
        await _repository.saveMeasurement(bmiMetricKey, bmi, date);
        ref.invalidate(progressHistoryProvider(bmiMetricKey));
        ref.invalidate(graphDataProvider(bmiMetricKey));
        derivedMetricSaved = true;
      }
    }

    // Vücut kompozisyonu girdisi değilse ve bodyFat değilse erken çık
    final bool isBodyCompositionMetric = _bodyCompositionInputs.contains(metric);
    if (!isBodyCompositionMetric && metric != bodyFatMetricKey) {
      if (derivedMetricSaved) {
        ref.invalidate(allProgressDataProvider);
      }
      return;
    }

    // 2) Body Fat → Lean Mass → FFMI
    final gender = profile.gender.toLowerCase();
    final bool hasValidGender = gender == 'male' || gender == 'female';

    final weightModel = metric == 'weight'
        ? ProgressModel(date: date, value: value)
        : await _repository.getMeasurementForDate('weight', date) ??
        await _repository.getLatestMeasurement('weight');

    if (weightModel == null) {
      if (derivedMetricSaved) {
        ref.invalidate(allProgressDataProvider);
      }
      return;
    }

    double? normalizedFat;

    if (isBodyCompositionMetric && hasValidGender && heightValue != null) {
      final waistModel =
          await _repository.getMeasurementForDate('waist', date) ??
              await _repository.getLatestMeasurement('waist');
      final neckModel =
          await _repository.getMeasurementForDate('neck', date) ??
              await _repository.getLatestMeasurement('neck');

      ProgressModel? hipModel;
      if (gender == 'female') {
        hipModel = await _repository.getMeasurementForDate('hip', date) ??
            await _repository.getLatestMeasurement('hip');
      }

      if (waistModel != null && neckModel != null) {
        if (gender == 'male' || (gender == 'female' && hipModel != null)) {
          final bodyFat = BodyFatUtils.calculateBodyFatPercentage(
            gender: gender,
            waist: waistModel.value,
            neck: neckModel.value,
            hip: hipModel?.value,
            height: heightValue,
          );

          if (bodyFat != null && bodyFat.isFinite && !bodyFat.isNaN) {
            normalizedFat = BodyFatUtils.normalizeBodyFat(bodyFat);

            await _repository.saveMeasurement(
              bodyFatMetricKey,
              normalizedFat,
              date,
            );
            ref.invalidate(progressHistoryProvider(bodyFatMetricKey));
            ref.invalidate(graphDataProvider(bodyFatMetricKey));
            derivedMetricSaved = true;
          }
        }
      }
    }

    normalizedFat ??= await _resolveExistingValue(bodyFatMetricKey, date);
    if (normalizedFat == null) {
      if (derivedMetricSaved) {
        ref.invalidate(allProgressDataProvider);
      }
      return;
    }

    final leanMass = BodyFatUtils.calculateLeanMass(
      weight: weightModel.value,
      bodyFatPercentage: normalizedFat,
    );

    if (leanMass.isFinite && !leanMass.isNaN) {
      await _repository.saveMeasurement(leanMassMetricKey, leanMass, date);
      ref.invalidate(progressHistoryProvider(leanMassMetricKey));
      ref.invalidate(graphDataProvider(leanMassMetricKey));
      derivedMetricSaved = true;

      if (heightValue != null && heightValue > 0) {
        final ffmi = BodyFatUtils.calculateFfmi(
          leanMassKg: leanMass,
          heightCm: heightValue,
        );
        if (ffmi != null) {
          await _repository.saveMeasurement(ffmiMetricKey, ffmi, date);
          ref.invalidate(progressHistoryProvider(ffmiMetricKey));
          ref.invalidate(graphDataProvider(ffmiMetricKey));
          derivedMetricSaved = true;
        }
      }
    }

    if (derivedMetricSaved) {
      ref.invalidate(allProgressDataProvider);
    }
  }

  Future<double?> _resolveExistingValue(String metric, String date) async {
    final model = await _repository.getMeasurementForDate(metric, date) ??
        await _repository.getLatestMeasurement(metric);
    return model?.value;
  }
}

// ------------------ Read-Only Providers (değişmedi) ------------------

// Tarihçe (history)
final progressHistoryProvider =
FutureProvider.family<List<ProgressModel>, String>((ref, metric) async {
  final userId = ref.watch(userIdProvider);
  final repo = ProgressRepository(userId: userId!);
  return await repo.getMeasurements(metric);
});

// Grafiğe uygun data (chart)
final graphDataProvider =
FutureProvider.family<List<ChartData>, String>((ref, metric) async {
  final userId = ref.watch(userIdProvider);
  final repo = ProgressRepository(userId: userId!);
  return await repo.getChartData(metric);
});

// Favori metrik (favorite metric)
final favoriteMetricProvider = FutureProvider<String?>((ref) async {
  final userId = ref.watch(userIdProvider);
  final repo = ProgressRepository(userId: userId!);
  return await repo.getFavoriteMetric();
});

// Seçilmiş metrik (UI local state)
final selectedMetricProvider =
NotifierProvider<SelectedMetricNotifier, String?>(SelectedMetricNotifier.new);

// Küçük local Notifier tanımı:
class SelectedMetricNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setMetric(String metric) => state = metric;
  void clear() => state = null;
}

// Tüm metriklerin verisi (prefetch)
final allProgressDataProvider =
FutureProvider<Map<String, List<ChartData>>>((ref) async {
  final userId = ref.watch(userIdProvider);
  final repo = ProgressRepository(userId: userId!);
  return await repo.getAllProgressData(metrics);
});

// En son ölçüm (stream)
final latestMeasurementProvider =
StreamProvider.family<ProgressModel?, String>((ref, metric) {
  final userId = ref.watch(userIdProvider);
  final repo = ProgressRepository(userId: userId!);
  return repo.watchLatestMeasurement(metric);
});
