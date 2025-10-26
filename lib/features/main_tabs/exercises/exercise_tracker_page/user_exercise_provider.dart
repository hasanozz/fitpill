import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitpill/core/models/chartData_model.dart';
import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/exercise_set_model.dart';
import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/personalbest_model.dart';
import 'user_exercise_repository.dart';
import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/volume_score_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'time_range/time_range_functions.dart';
import 'time_range/time_range_provider.dart';
part 'user_exercise_provider.g.dart';

/// ---------------------------------------------------------------------------
/// REPOSITORY DI (DEPENDENCY INJECTION)
/// ---------------------------------------------------------------------------
/// Not: Gerçekte authProvider’dan almak daha temiz; şimdilik mevcut düzene sadık.
final userExerciseRepositoryProvider = Provider<UserExerciseRepository>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception("NO USER");
  return UserExerciseRepository(userId: user.uid);
});

/// ---------------------------------------------------------------------------
/// USER-EXERCISE STATE (ASYNC) — Riverpod 3.x tarzı
/// ---------------------------------------------------------------------------
/// Eskiden: StateNotifier<AsyncValue<List<ExerciseSet>>> + StateNotifierProvider.family
/// Şimdi:   AsyncNotifier<List<ExerciseSet>> + AsyncNotifierProvider.family
///
/// Family argümanını `build(String exerciseId)` ile alıyoruz.
/// Bu sınıf, tek bir egzersizin (exerciseId) set listesini yönetir.
///


@riverpod
class UserExercise extends _$UserExercise {
  /// build içinde erişeceğiz (ref.watch…)
  late final UserExerciseRepository _repository;


  /// Family parametresi `build` argümanı olarak gelir:
  /// `@override Future<List<ExerciseSet>> build(String exerciseId)`
  @override
  Future<List<ExerciseSet>> build(String exerciseId) async {
    // 1) DI: repository’yi al
    _repository = ref.watch(userExerciseRepositoryProvider);

    // 2) Parametre zorunlu; yoksa patlat
    if (exerciseId.isEmpty) {
      throw ArgumentError('exerciseId is required for UserExerciseNotifier');
    }

    // 3) İlk yükleme
    return _fetchSets(exerciseId);
  }

  /// İç fonksiyon: repo’dan setleri çekip döndürür.
  Future<List<ExerciseSet>> _fetchSets(String exerciseId) async {
    final sets =
    await _repository.fetchSetsForExercise(exerciseId: exerciseId);
    // build() `return` ile state’i belirlediğinden burada sadece döndürürüz
    return sets;
  }

  /// Public API: Yeniden yükleme (ör. UI’da pull-to-refresh)
  Future<void> refresh(String exerciseId) async {
    state = const AsyncLoading(); // loading göster
    state = await AsyncValue.guard(() => _fetchSets(exerciseId));
  }

  /// Public API: Set ekle → ardından listeyi güncelle
  Future<void> addSet({required String exerciseId, required ExerciseSet set}) async {
    // Yazma işlemi: hata yakalama + state güvenli güncelleme
    final prev = state.value; // olası optimistic UI için elde tut
    state = const AsyncLoading();
    try {
      await _repository.addExerciseSet(set: set, exerciseId: exerciseId);
      // Güncel listeyi tekrar çek
      final fresh = await _fetchSets(exerciseId);
      state = AsyncData(fresh);
    } catch (e, st) {
      // Hata olursa eski değeri korumak istersen:
      state = AsyncError(e, st);
      if (prev != null) state = AsyncData(prev);
      rethrow;
    }
  }

  /// Public API: Set sil → ardından listeyi güncelle
  Future<void> deleteSet({required String exerciseId, required String setId}) async {
    final prev = state.value;
    state = const AsyncLoading();
    try {
      await _repository.deleteExerciseSet(exerciseId: exerciseId, setId: setId);
      final fresh = await _fetchSets(exerciseId);
      state = AsyncData(fresh);
    } catch (e, st) {
      state = AsyncError(e, st);
      if (prev != null) state = AsyncData(prev);
      rethrow;
    }
  }
}

/// Family provider: her exerciseId için ayrı bir AsyncNotifier instance’ı.
/// Kullanım: ref.watch(userExerciseProvider(exerciseId))
// The argument is the family parameter (exerciseId)
// final userExerciseProvider = AsyncNotifierProvider.family<
//     UserExerciseNotifier, List<ExerciseSet>, String>(
//       (exerciseId) {
//     // We ignore the argument here, because it's passed directly to
//     // the Notifier's build method later.
//     return UserExerciseNotifier();
//   },
// );
/// ---------------------------------------------------------------------------
/// TÜREV (DERIVED) PROVIDER’LAR — GRAFİK ve PERSONAL BEST
/// ---------------------------------------------------------------------------
/// Not: Aşağıdakiler, userExerciseProvider’dan gelen AsyncValue<List<ExerciseSet>>’i
/// .whenData(...) ile dönüştürerek yeni AsyncValue’lar üretirler.

/// ------ 1) Weight Line Chart (günlük max ağırlık) ----------
final weightChartDataProvider = Provider.family<
    AsyncValue<List<ChartData>>,
    ({String exerciseId, TimeRange range})>((ref, params) {
  final setsAsync = ref.watch(userExerciseProvider(params.exerciseId));
  final dtRange = rangeFor(params.range); // DateTimeRange? (null => All)

  // end gününü dahil edecek şekilde aralık kontrolü
  bool inRange(DateTime d) {
    if (dtRange == null) return true;
    final day = DateTime(d.year, d.month, d.day);
    final startDay =
    DateTime(dtRange.start.year, dtRange.start.month, dtRange.start.day);
    final nextEnd =
    DateTime(dtRange.end.year, dtRange.end.month, dtRange.end.day)
        .add(const Duration(days: 1));
    return !day.isBefore(startDay) && day.isBefore(nextEnd);
  }

  return setsAsync.whenData((sets) {
    final filtered = sets.where((s) => inRange(s.exerciseDate));

    // Günlük en ağır set (max weight) → ChartData
    final Map<DateTime, double> maxWeightsPerDay = {};
    for (final set in filtered) {
      final dayKey = DateTime(
          set.exerciseDate.year, set.exerciseDate.month, set.exerciseDate.day);
      final prev = maxWeightsPerDay[dayKey];
      if (prev == null || set.weight > prev) {
        maxWeightsPerDay[dayKey] = set.weight;
      }
    }

    final list = maxWeightsPerDay.entries
        .map((e) => ChartData(date: e.key, value: e.value))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return list;
  });
});

/// ------ 2) Volume/Score Line Chart (günlük toplam skor) ----------
final volumeScoreChartDataProvider = Provider.family<
    AsyncValue<List<ChartData>>,
    ({String exerciseId, TimeRange range})>((ref, params) {
  final setsAsync = ref.watch(userExerciseProvider(params.exerciseId));
  final dtRange = rangeFor(params.range);

  bool inRange(DateTime d) {
    if (dtRange == null) return true;
    final day = DateTime(d.year, d.month, d.day);
    final startDay =
    DateTime(dtRange.start.year, dtRange.start.month, dtRange.start.day);
    final nextEnd =
    DateTime(dtRange.end.year, dtRange.end.month, dtRange.end.day)
        .add(const Duration(days: 1));
    return !day.isBefore(startDay) && day.isBefore(nextEnd);
  }

  return setsAsync.whenData((sets) {
    final filtered = sets.where((s) => inRange(s.exerciseDate));

    final Map<DateTime, double> dailyScores = {};
    for (final set in filtered) {
      final dayKey = DateTime(
          set.exerciseDate.year, set.exerciseDate.month, set.exerciseDate.day);

      // Not: isim "calculateTrainingcore" olarak projede öyleyse değiştirmiyoruz.
      final score = calculateTrainingcore(weight: set.weight, reps: set.reps);
      dailyScores.update(dayKey, (p) => p + score, ifAbsent: () => score);
    }

    final list = dailyScores.entries
        .map((e) => ChartData(date: e.key, value: e.value))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return list;
  });
});

/// ------ 3) Personal Best (en ağır set & en yüksek skor) ----------
final personalBestProvider =
Provider.family<AsyncValue<PersonalBest?>, String>((ref, exerciseId) {
  final setsAsync = ref.watch(userExerciseProvider(exerciseId));

  return setsAsync.whenData((sets) {
    if (sets.isEmpty) return null;

    ExerciseSet heaviestSet = sets.first;
    ExerciseSet highestVolumeSet = sets.first;

    // Tek geçiş O(n): heaviest ve highest-volume set’i birlikte buluyoruz.
    for (final set in sets) {
      if (set.weight > heaviestSet.weight) {
        heaviestSet = set;
      }
      final currentVolume =
      calculateTrainingcore(weight: set.weight, reps: set.reps);
      final maxVolume = calculateTrainingcore(
          weight: highestVolumeSet.weight, reps: highestVolumeSet.reps);
      if (currentVolume > maxVolume) {
        highestVolumeSet = set;
      }
    }

    return PersonalBest(
      heaviestSet: heaviestSet,
      highestVolumeSet: highestVolumeSet,
    );
  });
});
