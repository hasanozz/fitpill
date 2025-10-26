// lib/features/weekly_routines/workouts_screen_provider.dart
// Riverpod 3.0.3 uyumlu sürüm (çalışır halde)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpill/features/auth/auth_provider.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';

import 'workouts_screen_model.dart';
import 'workouts_screen_repository.dart';

// -----------------------------------------------------------------------------
// Repository provider (değişmedi)
// -----------------------------------------------------------------------------
final routineRepositoryProvider = Provider<RoutineRepository>(
      (ref) => RoutineRepository(firestore: FirebaseFirestore.instance),
);

// -----------------------------------------------------------------------------
// ROUTINE LIST CONTROLLER  (Eski: StateNotifier<AsyncValue<List<...>>>)
// Yeni: AsyncNotifier<List<...>>
// -----------------------------------------------------------------------------
final routineProvider =
AsyncNotifierProvider<RoutineNotifier, List<WorkoutRoutineModel>>(
  RoutineNotifier.new,
);

class RoutineNotifier extends AsyncNotifier<List<WorkoutRoutineModel>> {
  late final RoutineRepository _repository;
  late final String _userId;

  @override
  Future<List<WorkoutRoutineModel>> build() async {
    // userId null ise bu controller kullanılamaz → defansif kontrol
    final uid = ref.watch(userIdProvider);
    if (uid == null) {
      throw StateError('User is not signed in.');
    }

    _userId = uid;
    _repository = ref.watch(routineRepositoryProvider);

    // İlk yükleme
    return _repository.fetchRoutines(_userId);
  }

  // Premium kontrolü (profileProvider üzerinden)
  Future<bool> _hasPremiumAccess() async {
    final profileState = ref.read(profileProvider);
    final profile = profileState.value;
    if (profile != null) return profile.hasActivePremium;

    // Henüz yüklenmemişse manuel fetch etmeyi deneyelim
    await ref.read(profileProvider.notifier).fetchProfile();
    final refreshed = ref.read(profileProvider).value;
    return refreshed?.hasActivePremium ?? false;
  }

  Future<void> fetchRoutines() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchRoutines(_userId));
  }

  Future<void> addRoutine(String name) async {
    if (!await _hasPremiumAccess()) {
      throw StateError('Premium membership required to create routines.');
    }
    // Mutasyon → sonra listeyi yeniden çek
    await _repository.addRoutine(_userId, name);
    await fetchRoutines();
  }

  Future<void> deleteRoutine(String id) async {
    await _repository.deleteRoutine(_userId, id);
    await fetchRoutines();
  }

  Future<void> updateRoutine(String id, String newName) async {
    await _repository.updateRoutine(_userId, id, newName);
    await fetchRoutines();
  }
}

// -----------------------------------------------------------------------------
// WORKOUT COMMAND CONTROLLER (Eski: StateNotifier<AsyncValue<void>>)
// Yeni: AsyncNotifier<void>
// -----------------------------------------------------------------------------
final workoutProvider =
AsyncNotifierProvider<WorkoutNotifier, void>(WorkoutNotifier.new);

class WorkoutNotifier extends AsyncNotifier<void> {
  late final RoutineRepository _repository;
  late final String _userId;

  @override
  Future<void> build() async {
    final uid = ref.watch(userIdProvider);
    if (uid == null) {
      state = AsyncError(StateError('User is not signed in.'), StackTrace.current);
      return;
    }
    _userId = uid;
    _repository = ref.watch(routineRepositoryProvider);

    // Bu controller "komut" çalıştırır, elde tutulacak veri yok → data:null
    state = const AsyncData(null);
  }

  Future<void> addWorkout(String routineId, WorkoutModel workout) async {
    state = const AsyncLoading();
    try {
      await _repository.addWorkout(
        userId: _userId,
        routineId: routineId,
        workout: workout,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteWorkout(String routineId, String workoutId) async {
    state = const AsyncLoading();
    try {
      await _repository.deleteWorkout(
        userId: _userId,
        routineId: routineId,
        workoutId: workoutId,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateWorkout({
    required String routineId,
    required String workoutId,
    required String newName,
    required int newDayIndex,
    required String newDayLabel,
  }) async {
    state = const AsyncLoading();
    try {
      await _repository.updateWorkoutData(
        userId: _userId,
        routineId: routineId,
        workoutId: workoutId,
        newName: newName,
        newDayIndex: newDayIndex,
        newDayLabel: newDayLabel,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// -----------------------------------------------------------------------------
// READ-ONLY DATA (değişmedi)
// -----------------------------------------------------------------------------
final workoutListProvider =
FutureProvider.family<List<WorkoutModel>, String>((ref, routineId) async {
  final repo = ref.watch(routineRepositoryProvider);
  final userId = ref.watch(userIdProvider);
  if (userId == null) throw StateError('User is not signed in.');
  return repo.getWorkouts(userId: userId, routineId: routineId);
});

// -----------------------------------------------------------------------------
// UI LOCAL STATE (StateProvider yerine minik Notifier’lar)
// Riverpod 3.0.3 bazı kurulumlarda StateProvider adını çözümleyemiyor.
// Bu nedenle Notifier tabanlı local state, daha kararlı.
// -----------------------------------------------------------------------------

// expandedTileIdsProvider: Set<String>
final expandedTileIdsProvider =
NotifierProvider<ExpandedTileIdsNotifier, Set<String>>(
    ExpandedTileIdsNotifier.new);

class ExpandedTileIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void toggle(String id) {
    final s = {...state};
    if (s.contains(id)) {
      s.remove(id);
    } else {
      s.add(id);
    }
    state = s;
  }

  void clear() => state = <String>{};
}

// openTileKeyProvider: String?
final openTileKeyProvider =
NotifierProvider<OpenTileKeyNotifier, String?>(OpenTileKeyNotifier.new);

class OpenTileKeyNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? key) => state = key;
}

// expandedTileIndexProvider: int?
final expandedTileIndexProvider =
NotifierProvider<ExpandedTileIndexNotifier, int?>(
    ExpandedTileIndexNotifier.new);

class ExpandedTileIndexNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void set(int? idx) => state = idx;
}

// openSlidableIdProvider: String?
final openSlidableIdProvider =
NotifierProvider<OpenSlidableIdNotifier, String?>(
    OpenSlidableIdNotifier.new);

class OpenSlidableIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? id) => state = id;
}
