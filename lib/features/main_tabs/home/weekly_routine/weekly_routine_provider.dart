// weekly_routine_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart'; // localeInitializationProvider için BuildContext'i taklit etmek zorunda kaldık
import 'package:fitpill/core/system/services/notification_service.dart';
import 'package:fitpill/core/system/config/locale/locale_notifier.dart';

import 'weekly_routine_models.dart';
import 'package:fitpill/generated/l10n/l10n.dart'; // S.current'ı kullanmak için

const _weeklyRoutinePrefsKey = 'weekly_routine_state_v1';
const _weeklyRoutineAnalyticsPrefsKey = 'weekly_routine_analytics_v1';

class WeeklyRoutineNotifier extends AsyncNotifier<WeeklyRoutineData> {
  WeeklyRoutineNotifier();

  SharedPreferences? _prefs;

  @override
  Future<WeeklyRoutineData> build() async {
    // 1) Riverpod 3.0: locale değiştiğinde bu build() metodunu tekrar çalıştır.
    final locale = ref.watch(localizationProvider);

    // 2) locale yüklemesi bitsin (güvenli başlangıç için kalmalı):
    await ref.read(localeInitializationProvider.future);

    // 3) SharedPreferences al
    _prefs = await SharedPreferences.getInstance();
    final storedRoutine = _prefs!.getString(_weeklyRoutinePrefsKey);
    final storedAnalytics = _prefs!.getString(_weeklyRoutineAnalyticsPrefsKey);


    final routine = storedRoutine == null
        ? WeeklyRoutineState.initial()
        : WeeklyRoutineState.fromJson(storedRoutine);
    final analytics = storedAnalytics == null
        ? WeeklyRoutineAnalytics.initial()
        : WeeklyRoutineAnalytics.fromJson(storedAnalytics);

    final data = WeeklyRoutineData(routine: routine, analytics: analytics);
    final normalized = await _normalizeForCurrentDate(data);

    // 4) Çeviri nesnesini al. S.current'a erişim yapıldı varsayılır.
    // DİKKAT: Eğer bu metodun çalıştığı anda S.current null ise, uygulamanın başka bir
    // yerinde (örneğin ana widget'ta) S.of(context) çağrılmamış demektir.
    final strings = ref.watch(currentStringsProvider);

    if (strings!=null) {

      await NotificationService.syncRoutineSchedule(
        routine: normalized.routine,
        translateWorkout: (workoutTitle) => strings.weeklyRoutineNotificationBody(workoutTitle),
        translateTitle: () => strings.weeklyRoutineNotificationTitle,

      );

    }else {
      // strings null geldiğinde bildirim senkronizasyonunu atla
      // veya bu durum için bir loglama/uyarı ekle.
      debugPrint('UYARI: Çeviri nesnesi (strings) henüz yüklenmedi. Bildirimler atlandı.');
    }

    return normalized;
  }

  // ... (assignWorkout, markOffDay, clearDay, toggleCompletion metotları aynı kalır)

  Future<void> assignWorkout(
      Weekday day,
      WeeklyWorkoutSelection selection,
      ) async {
    final current = await _getCurrentData();
    final updatedEntry = current.routine.entries[day]!.copyWith(
      isOffDay: false,
      isCompleted: false,
      selection: selection,
    );
    await _updateState(current, day, updatedEntry);
  }

  Future<void> markOffDay(Weekday day) async {
    final current = await _getCurrentData();
    final updatedEntry = current.routine.entries[day]!.copyWith(
      isOffDay: true,
      isCompleted: false,
      selection: null,
      selectionProvided: true,
    );
    await _updateState(current, day, updatedEntry);
  }

  Future<void> clearDay(Weekday day) async {
    final current = await _getCurrentData();
    final updatedEntry = current.routine.entries[day]!.copyWith(
      isOffDay: false,
      isCompleted: false,
      selection: null,
      selectionProvided: true,
    );
    await _updateState(current, day, updatedEntry);
  }

  Future<void> toggleCompletion(Weekday day) async {
    final now = DateTime.now();
    if (day != weekdayFromDate(now)) {
      return;
    }

    final current = await _getCurrentData();
    final existing = current.routine.entries[day]!;
    if (existing.isOffDay || existing.selection == null) {
      return;
    }

    final updatedEntry = existing.copyWith(
      isCompleted: !existing.isCompleted,
    );
    await _updateState(current, day, updatedEntry);
  }


  Future<void> _updateState(
      WeeklyRoutineData current,
      Weekday day,
      WeeklyRoutineEntry entry,
      ) async {
    final previousEntry = current.routine.entries[day]!;
    var analytics = current.analytics;

    if (previousEntry.isCompleted != entry.isCompleted) {
      final delta = entry.isCompleted ? 1 : -1;
      analytics = _applyCompletionDelta(analytics, delta);
    }

    final updatedMap =
    Map<Weekday, WeeklyRoutineEntry>.from(current.routine.entries)
      ..[day] = entry;
    final updatedState = WeeklyRoutineState(entries: updatedMap);
    final updatedData = current.copyWith(
      routine: updatedState,
      analytics: analytics,
    );
    state = AsyncData(updatedData);
    await _persist(updatedData);

    // 5) _updateState içinde locale yerine strings almalıyız.
    // Burası build() metodundan bağımsız çalıştığı için ref.watch kullanamayız.
    // Sadece S.current'a güvenebiliriz.
    final strings = ref.read(currentStringsProvider);

    if (strings != null) {
      await NotificationService.syncRoutineSchedule(
        routine: updatedState,
        translateWorkout: (workoutTitle) => strings.weeklyRoutineNotificationBody(workoutTitle),
        translateTitle: () => strings.weeklyRoutineNotificationTitle,
      );
    }else {
      // strings null geldiğinde bildirim senkronizasyonunu atla
      // veya bu durum için bir loglama/uyarı ekle.
      debugPrint('UYARI: Çeviri nesnesi (strings) henüz yüklenmedi. Bildirimler atlandı.');
    }


  }

  // ... (Kalan metotlar (_applyCompletionDelta, _persist, _normalizeForCurrentDate, _getCurrentData) aynı kalır)

  WeeklyRoutineAnalytics _applyCompletionDelta(
      WeeklyRoutineAnalytics analytics,
      int delta,
      ) {
    if (delta == 0) {
      return analytics;
    }

    final totals = Map<String, int>.from(analytics.monthlyTotals);
    final activeMonthKey = analytics.activeMonthKey;
    totals.putIfAbsent(activeMonthKey, () => 0);
    final currentMonthTotal = totals[activeMonthKey] ?? 0;
    final updatedMonthTotal = currentMonthTotal + delta;
    totals[activeMonthKey] = updatedMonthTotal < 0 ? 0 : updatedMonthTotal;

    final updatedWeekCount = analytics.currentWeekCompletedCount + delta;
    final safeWeekCount = updatedWeekCount < 0
        ? 0
        : (updatedWeekCount > Weekday.values.length
        ? Weekday.values.length
        : updatedWeekCount);

    return analytics.copyWith(
      monthlyTotals: totals,
      currentWeekCompletedCount: safeWeekCount,
    );
  }

  Future<void> _persist(WeeklyRoutineData data) async {
    await _prefs?.setString(_weeklyRoutinePrefsKey, data.routine.toJson());
    await _prefs
        ?.setString(_weeklyRoutineAnalyticsPrefsKey, data.analytics.toJson());
  }

  Future<WeeklyRoutineData> _normalizeForCurrentDate(
      WeeklyRoutineData data,
      ) async {
    final now = DateTime.now();
    final desiredWeekAnchor = startOfWeek(now);
    var routine = data.routine;
    var analytics = data.analytics;
    var changed = false;

    if (!isSameDate(desiredWeekAnchor, analytics.weekAnchor)) {
      final completedCount = routine.entries.values
          .where((entry) => entry.isCompleted)
          .length;
      final totals = Map<String, int>.from(analytics.monthlyTotals);
      final previousMonthKey = monthKey(analytics.weekAnchor);
      totals.putIfAbsent(previousMonthKey, () => 0);
      final delta = completedCount - analytics.currentWeekCompletedCount;
      if (delta != 0) {
        final updatedTotal = totals[previousMonthKey]! + delta;
        totals[previousMonthKey] = updatedTotal < 0 ? 0 : updatedTotal;
      }

      final resetEntries = <Weekday, WeeklyRoutineEntry>{};
      for (final entry in routine.entries.entries) {
        resetEntries[entry.key] = entry.value.copyWith(isCompleted: false);
      }

      routine = WeeklyRoutineState(entries: resetEntries);
      analytics = analytics.copyWith(
        weekAnchor: desiredWeekAnchor,
        monthlyTotals: totals,
        currentWeekCompletedCount: 0,
      );
      changed = true;
    }

    final currentMonthKey = monthKey(now);
    if (analytics.activeMonthKey != currentMonthKey) {
      final totals = Map<String, int>.from(analytics.monthlyTotals);
      totals.putIfAbsent(currentMonthKey, () => 0);
      analytics = analytics.copyWith(
        activeMonthKey: currentMonthKey,
        monthlyTotals: totals,
      );
      changed = true;
    } else if (!analytics.monthlyTotals.containsKey(currentMonthKey)) {
      final totals = Map<String, int>.from(analytics.monthlyTotals)
        ..[currentMonthKey] = 0;
      analytics = analytics.copyWith(monthlyTotals: totals);
      changed = true;
    }

    if (changed) {
      final normalized = data.copyWith(
        routine: routine,
        analytics: analytics,
      );
      await _persist(normalized);
      state = AsyncData(normalized);
      return normalized;
    }

    return data;
  }

  Future<WeeklyRoutineData> _getCurrentData() async {
    final current = await future;
    return _normalizeForCurrentDate(current);
  }
}

final weeklyRoutineProvider =
AsyncNotifierProvider<WeeklyRoutineNotifier, WeeklyRoutineData>(
  WeeklyRoutineNotifier.new,
);