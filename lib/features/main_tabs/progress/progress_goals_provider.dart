import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpill/features/auth/auth_provider.dart';
import 'package:fitpill/features/main_tabs/home/badge/badge_provider.dart';
import 'package:fitpill/features/main_tabs/progress/progress_goals_repository.dart';
import 'progress_goal_model.dart';

/// Repository DI (userId'den bağlanır)
final progressGoalsRepositoryProvider = Provider<ProgressGoalsRepository>((ref) {
  final userId = ref.watch(userIdProvider);
  return ProgressGoalsRepository(userId: userId!);
});

/// Canlı izleme gerekiyorsa StreamProvider aynı kalabilir
final progressGoalsStreamProvider = StreamProvider<List<ProgressGoal>>((ref) {
  final repository = ref.watch(progressGoalsRepositoryProvider);
  return repository.watchGoals();
});

/// ---- AsyncNotifier Provider (3.x) ----
final progressGoalsProvider = AsyncNotifierProvider<ProgressGoalsNotifier, List<ProgressGoal>>(
  ProgressGoalsNotifier.new,
);

/// ---- Notifier (3.x) ----
/// State: AsyncValue<List<ProgressGoal>>
class ProgressGoalsNotifier extends AsyncNotifier<List<ProgressGoal>> {
  late final ProgressGoalsRepository _repository;

  @override
  Future<List<ProgressGoal>> build() async {
    _repository = ref.watch(progressGoalsRepositoryProvider);
    // İlk yükleme
    return _repository.fetchGoals();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchGoals());
  }

  Future<void> addGoal({
    required String metric,
    required double startValue,
    required double targetValue,
    required DateTime targetDate,
  }) async {
    try {
      final newGoal = await _repository.createGoal(
        metric: metric,
        startValue: startValue,
        targetValue: targetValue,
        targetDate: targetDate,
      );
      // Optimistic update: mevcut listeye ekle
      final current = state.asData?.value ?? const <ProgressGoal>[];
      state = AsyncValue.data([newGoal, ...current]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await _repository.deleteGoal(id);
      final current = state.asData?.value ?? const <ProgressGoal>[];
      state = AsyncValue.data(current.where((g) => g.id != id).toList());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markCompleted(ProgressGoal goal, {double? finalValue}) async {
    try {
      await _repository.markGoalCompleted(goal, finalValue: finalValue);
      await refresh();                 // listeyi tazele
      ref.invalidate(badgeProvider);   // rozetleri güncelle
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateGoal(ProgressGoal goal) async {
    try {
      await _repository.updateGoal(goal);
      await refresh();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
