// activity_tracker_provider.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitpill/features/main_tabs/home/do_with_me/activity_model.dart';
import 'package:fitpill/features/main_tabs/home/do_with_me/activity_repository.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';
import 'package:fitpill/features/main_tabs/home/do_with_me/do_with_me_activity_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_tracker_provider.g.dart';

// PARAMS CLASS
class ActivityTrackerParams {
// ... (Aynı kalır)
  final Activity activity;
  final String tempoKey;
  final double incline;
  final int targetMinutes;

  const ActivityTrackerParams({
    required this.activity,
    required this.tempoKey,
    required this.incline,
    required this.targetMinutes,
  });
}

// STATE CLASS
class ActivityTrackerState {
// ... (Aynı kalır)
  final bool isRunning;
  final bool isPaused;
  final Duration totalElapsed;
  final double caloriesBurned;

  const ActivityTrackerState({
    required this.isRunning,
    required this.isPaused,
    required this.totalElapsed,
    required this.caloriesBurned,
  });

  factory ActivityTrackerState.initial() {
    return const ActivityTrackerState(
      isRunning: false,
      isPaused: false,
      totalElapsed: Duration.zero,
      caloriesBurned: 0.0,
    );
  }

  ActivityTrackerState copyWith({
    bool? isRunning,
    bool? isPaused,
    Duration? totalElapsed,
    double? caloriesBurned,
  }) {
    return ActivityTrackerState(
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      totalElapsed: totalElapsed ?? this.totalElapsed,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    );
  }
}

// NOTIFIER CLASS (GENERATOR KULLANIMI)
@riverpod
class ActivityTracker extends _$ActivityTracker {

  Timer? _timer;
  DateTime? _lastResumeTime;

  late final ActivityRepository _repository;
  late final Activity _activity;
  late final String _tempoKey;
  late final double _incline;
  late final int _targetMinutes;

  @override
  ActivityTrackerState build(ActivityTrackerParams params) {

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Kullanıcı bulunamadı');
    }
    _repository = ActivityRepository(userId: user.uid);

    _activity = params.activity;
    _tempoKey = params.tempoKey;
    _incline = params.incline;
    _targetMinutes = params.targetMinutes;

    ref.onDispose(() {
      _timer?.cancel();
    });

    return ActivityTrackerState.initial();
  }

  void start() {
    if (state.isRunning) return;

    _lastResumeTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPaused) {
        state = state.copyWith(
          totalElapsed: state.totalElapsed + const Duration(seconds: 1),
          caloriesBurned: _calculateCalories(state.totalElapsed + const Duration(seconds: 1)),
        );
      }
    });

    state = state.copyWith(isRunning: true, isPaused: false);
  }

  void pause() {
    if (!state.isRunning || state.isPaused) return;
    _timer?.cancel();
    state = state.copyWith(isPaused: true);
  }

  void resume() {
    if (!state.isRunning || !state.isPaused) return;

    _lastResumeTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPaused) {
        state = state.copyWith(
          totalElapsed: state.totalElapsed + const Duration(seconds: 1),
          caloriesBurned: _calculateCalories(state.totalElapsed + const Duration(seconds: 1)),
        );
      }
    });

    state = state.copyWith(isPaused: false);
  }

  Future<bool> stop() async {
    _timer?.cancel();

    if (!state.isPaused && state.isRunning && _lastResumeTime != null) {
      final now = DateTime.now();
      final elapsed = now.difference(_lastResumeTime!);
      state = state.copyWith(
        totalElapsed: state.totalElapsed + elapsed,
        caloriesBurned: _calculateCalories(state.totalElapsed + elapsed),
      );
    }

    final hasPremium = await _hasPremiumAccess();

    if (hasPremium) {
      final newActivity = ActivityModel(
        id: '',
        activityName: _activity.name,
        durationInSeconds: state.totalElapsed.inSeconds,
        caloriesBurned: state.caloriesBurned,
        timestamp: DateTime.now(),
        incline: (_activity.name == 'walk' || _activity.name == 'run')
            ? _incline
            : null,
        tempoKey: _tempoKey,
      );

      await _repository.addActivity(newActivity);
    }

    state = state.copyWith(isRunning: false, isPaused: false);
    return hasPremium;
  }

  Future<bool> _hasPremiumAccess() async {
    final profileState = ref.read(profileProvider);
    final profile = profileState.asData?.value;
    if (profile != null) return profile.hasActivePremium;

    if (profileState.isLoading) {
      await ref.read(profileProvider.notifier).fetchProfile();
      final refreshedProfile = ref.read(profileProvider).asData?.value;
      if (refreshedProfile != null) {
        return refreshedProfile.hasActivePremium;
      }
    }

    return false;
  }

  double _calculateCalories(Duration elapsed) {
    double metValue = 4.0;
    // ... (Aynı kalır)
    switch (_activity.name) {
      case 'walk':
        if (_tempoKey == 'low') metValue = 3.0;
        if (_tempoKey == 'medium') metValue = 4.0;
        if (_tempoKey == 'high') metValue = 5.0;
        break;
      case 'run':
        if (_tempoKey == 'low') metValue = 6.0;
        if (_tempoKey == 'medium') metValue = 8.0;
        if (_tempoKey == 'high') metValue = 10.0;
        break;
      case 'bicycle':
        if (_tempoKey == 'low') metValue = 4.0;
        if (_tempoKey == 'medium') metValue = 6.0;
        if (_tempoKey == 'high') metValue = 8.0;
        break;
      case 'weightlifting':
        if (_tempoKey == 'low') metValue = 3.0;
        if (_tempoKey == 'medium') metValue = 4.0;
        if (_tempoKey == 'high') metValue = 5.0;
        break;
    }

    if (_activity.name == 'walk' || _activity.name == 'run') {
      metValue += (_incline / 5) * 0.2 * metValue;
    }

    const double defaultWeight = 70.0;
    return (metValue * defaultWeight * elapsed.inSeconds / 3600)
        .roundToDouble();
  }
}