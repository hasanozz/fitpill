import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpill/features/auth/auth_provider.dart';
import 'package:fitpill/features/main_tabs/home/do_with_me/activity_model.dart';
import 'package:fitpill/features/main_tabs/home/do_with_me/activity_repository.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';

/// 🔹 Activity repository provider
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final userId = ref.watch(userIdProvider);
  if (userId == null) throw Exception("No user logged in");
  return ActivityRepository(userId: userId);
});

/// 🔹 Activity provider (AsyncNotifier)
final activityProvider =
AsyncNotifierProvider<ActivityNotifier, List<ActivityModel>>(
  ActivityNotifier.new,
);

/// 🔹 Notifier (Riverpod 3.x sürümü)
class ActivityNotifier extends AsyncNotifier<List<ActivityModel>> {
  late final ActivityRepository _repository;

  @override
  Future<List<ActivityModel>> build() async {
    _repository = ref.watch(activityRepositoryProvider);
    // İlk yükleme sırasında aktiviteleri çek
    return _repository.fetchActivities();
  }

  /// Premium erişim kontrolü
  Future<bool> _hasPremiumAccess() async {
    final profileState = ref.read(profileProvider);
    final profile = profileState.asData?.value;
    if (profile != null) return profile.hasActivePremium;

    if (profileState.isLoading) {
      await ref.read(profileProvider.notifier).fetchProfile();
      final refreshed = ref.read(profileProvider).asData?.value;
      if (refreshed != null) {
        return refreshed.hasActivePremium;
      }
    }
    return false;
  }

  /// Listeyi tazele
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchActivities());
  }

  /// Aktivite ekleme
  Future<void> addActivity(ActivityModel activity) async {
    try {
      final hasPremium = await _hasPremiumAccess();
      if (!hasPremium) return;

      await _repository.addActivity(activity);
      await refresh();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Aktivite silme
  Future<void> deleteActivity(String activityId) async {
    try {
      await _repository.deleteActivity(activityId);
      await refresh();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
