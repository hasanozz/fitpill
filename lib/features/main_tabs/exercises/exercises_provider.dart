// lib/features/exercises/exercises_provider.dart
// Riverpod 3.0.3 uyumlu sürüm
// -----------------------------------------------------------------------------
// Bu dosya neden dönüştürüldü?
//  - StateNotifier yerine AsyncNotifier kullanarak AsyncValue lifecycle desteği ekledik.
//  - build() içinde veriler Firestore'dan otomatik yükleniyor.
//  - UI tarafında ref.watch(exercisesProvider) => AsyncValue<List<Exercise>> döner.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'exercise_model.dart';
import 'exercises_repository.dart';

// -----------------------------------------------------------------------------
// Repository Provider
// -----------------------------------------------------------------------------
final exerciseRepositoryProvider = Provider<ExerciseRepository>(
      (ref) => ExerciseRepository(),
);

// -----------------------------------------------------------------------------
// Exercises Controller
// -----------------------------------------------------------------------------
final exercisesProvider =
AsyncNotifierProvider<ExercisesNotifier, List<Exercise>>(
  ExercisesNotifier.new,
);

class ExercisesNotifier extends AsyncNotifier<List<Exercise>> {
  late final ExerciseRepository _repository;

  // build() sadece ilk yükleme sırasında çağrılır.
  @override
  Future<List<Exercise>> build() async {
    _repository = ref.watch(exerciseRepositoryProvider);

    // Firestore'dan egzersizleri yükle
    final exercises = await _repository.loadExercisesFromFirestore();
    return exercises;
  }

  // Egzersiz listesini yeniden yükle
  Future<void> reloadExercises() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await _repository.loadExercisesFromFirestore();
    });
  }

  // State'i temizle (ör. kullanıcı çıkışında)
  void clear() {
    state = const AsyncData([]);
  }
}
