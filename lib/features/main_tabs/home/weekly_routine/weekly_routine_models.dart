import 'dart:convert';

import 'package:flutter/foundation.dart';

enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

enum WeeklyRoutineSource { personal, fitpil }

@immutable
class WeeklyWorkoutSelection {
  const WeeklyWorkoutSelection({
    required this.id,
    required this.title,
    required this.source,
    this.subtitle,
    this.routineId,
    this.routineName,
  });

  final String id;
  final String title;
  final WeeklyRoutineSource source;
  final String? subtitle;
  final String? routineId;
  final String? routineName;

  WeeklyWorkoutSelection copyWith({
    String? id,
    String? title,
    WeeklyRoutineSource? source,
    String? subtitle,
    String? routineId,
    String? routineName,
  }) {
    return WeeklyWorkoutSelection(
      id: id ?? this.id,
      title: title ?? this.title,
      source: source ?? this.source,
      subtitle: subtitle ?? this.subtitle,
      routineId: routineId ?? this.routineId,
      routineName: routineName ?? this.routineName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'source': source.name,
      'subtitle': subtitle,
      'routineId': routineId,
      'routineName': routineName,
    };
  }

  factory WeeklyWorkoutSelection.fromMap(Map<String, dynamic> map) {
    return WeeklyWorkoutSelection(
      id: map['id'] as String,
      title: map['title'] as String,
      source: WeeklyRoutineSource.values.firstWhere(
        (element) => element.name == map['source'],
        orElse: () => WeeklyRoutineSource.personal,
      ),
      subtitle: map['subtitle'] as String?,
      routineId: map['routineId'] as String?,
      routineName: map['routineName'] as String?,
    );
  }
}

@immutable
class WeeklyRoutineEntry {
  const WeeklyRoutineEntry({
    required this.day,
    this.isOffDay = false,
    this.isCompleted = false,
    this.selection,
  });

  final Weekday day;
  final bool isOffDay;
  final bool isCompleted;
  final WeeklyWorkoutSelection? selection;

  WeeklyRoutineEntry copyWith({
    bool? isOffDay,
    bool? isCompleted,
    WeeklyWorkoutSelection? selection,
    bool selectionProvided = false,
  }) {
    return WeeklyRoutineEntry(
      day: day,
      isOffDay: isOffDay ?? this.isOffDay,
      isCompleted: isCompleted ?? this.isCompleted,
      selection: selectionProvided
          ? selection
          : (selection ?? this.selection),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day.name,
      'isOffDay': isOffDay,
      'isCompleted': isCompleted,
      'selection': selection?.toMap(),
    };
  }

  factory WeeklyRoutineEntry.fromMap(Map<String, dynamic> map) {
    final selectionMap = map['selection'] as Map<String, dynamic>?;
    return WeeklyRoutineEntry(
      day: Weekday.values.firstWhere(
        (element) => element.name == map['day'],
        orElse: () => Weekday.monday,
      ),
      isOffDay: map['isOffDay'] as bool? ?? false,
      isCompleted: map['isCompleted'] as bool? ?? false,
      selection:
          selectionMap == null ? null : WeeklyWorkoutSelection.fromMap(selectionMap),
    );
  }
}

@immutable
class WeeklyRoutineAnalytics {
  const WeeklyRoutineAnalytics({
    required this.weekAnchor,
    required this.activeMonthKey,
    required this.monthlyTotals,
    required this.currentWeekCompletedCount,
  });

  factory WeeklyRoutineAnalytics.initial() {
    final now = DateTime.now();
    final currentWeekStart = startOfWeek(now);
    final currentMonthKey = monthKey(now);
    return WeeklyRoutineAnalytics(
      weekAnchor: currentWeekStart,
      activeMonthKey: currentMonthKey,
      monthlyTotals: {currentMonthKey: 0},
      currentWeekCompletedCount: 0,
    );
  }

  final DateTime weekAnchor;
  final String activeMonthKey;
  final Map<String, int> monthlyTotals;
  final int currentWeekCompletedCount;

  WeeklyRoutineAnalytics copyWith({
    DateTime? weekAnchor,
    String? activeMonthKey,
    Map<String, int>? monthlyTotals,
    int? currentWeekCompletedCount,
  }) {
    return WeeklyRoutineAnalytics(
      weekAnchor: weekAnchor ?? this.weekAnchor,
      activeMonthKey: activeMonthKey ?? this.activeMonthKey,
      monthlyTotals: monthlyTotals ?? this.monthlyTotals,
      currentWeekCompletedCount:
          currentWeekCompletedCount ?? this.currentWeekCompletedCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weekAnchor': weekAnchor.toIso8601String(),
      'activeMonthKey': activeMonthKey,
      'monthlyTotals': monthlyTotals,
      'currentWeekCompletedCount': currentWeekCompletedCount,
    };
  }

  factory WeeklyRoutineAnalytics.fromMap(Map<String, dynamic> map) {
    final totals = <String, int>{};
    final totalsMap = map['monthlyTotals'] as Map?;
    if (totalsMap != null) {
      totalsMap.forEach((key, value) {
        if (value is num) {
          totals[key.toString()] = value.toInt();
        }
      });
    }

    final currentWeekCount = (map['currentWeekCompletedCount'] as num?)?.toInt();

    return WeeklyRoutineAnalytics(
      weekAnchor: DateTime.tryParse(map['weekAnchor'] as String? ?? '') ??
          startOfWeek(DateTime.now()),
      activeMonthKey: map['activeMonthKey'] as String? ?? monthKey(DateTime.now()),
      monthlyTotals: totals.isEmpty
          ? {monthKey(DateTime.now()): 0}
          : totals,
      currentWeekCompletedCount: currentWeekCount ?? 0,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory WeeklyRoutineAnalytics.fromJson(String source) {
    return WeeklyRoutineAnalytics.fromMap(
      (jsonDecode(source) as Map).cast<String, dynamic>(),
    );
  }

  int totalForMonth(String monthKey) {
    return monthlyTotals[monthKey] ?? 0;
  }
}

@immutable
class WeeklyRoutineData {
  const WeeklyRoutineData({
    required this.routine,
    required this.analytics,
  });

  final WeeklyRoutineState routine;
  final WeeklyRoutineAnalytics analytics;

  WeeklyRoutineData copyWith({
    WeeklyRoutineState? routine,
    WeeklyRoutineAnalytics? analytics,
  }) {
    return WeeklyRoutineData(
      routine: routine ?? this.routine,
      analytics: analytics ?? this.analytics,
    );
  }
}

@immutable
class WeeklyRoutineState {
  const WeeklyRoutineState({required this.entries});

  final Map<Weekday, WeeklyRoutineEntry> entries;

  factory WeeklyRoutineState.initial() {
    return WeeklyRoutineState(
      entries: {
        for (final day in Weekday.values) day: WeeklyRoutineEntry(day: day),
      },
    );
  }

  WeeklyRoutineState copyWith({Map<Weekday, WeeklyRoutineEntry>? entries}) {
    return WeeklyRoutineState(entries: entries ?? this.entries);
  }

  Map<String, dynamic> toMap() {
    return entries.map((key, value) => MapEntry(key.name, value.toMap()));
  }

  factory WeeklyRoutineState.fromMap(Map<String, dynamic> map) {
    final mappedEntries = <Weekday, WeeklyRoutineEntry>{};
    for (final entry in map.entries) {
      final day = Weekday.values.firstWhere(
        (element) => element.name == entry.key,
        orElse: () => Weekday.monday,
      );
      mappedEntries[day] = WeeklyRoutineEntry.fromMap(
          (entry.value as Map).cast<String, dynamic>());
    }
    return WeeklyRoutineState(entries: mappedEntries);
  }

  String toJson() => jsonEncode(toMap());

  factory WeeklyRoutineState.fromJson(String source) {
    return WeeklyRoutineState.fromMap(
        (jsonDecode(source) as Map).cast<String, dynamic>());
  }
}

Weekday weekdayFromDate(DateTime date) {
  switch (date.weekday) {
    case DateTime.monday:
      return Weekday.monday;
    case DateTime.tuesday:
      return Weekday.tuesday;
    case DateTime.wednesday:
      return Weekday.wednesday;
    case DateTime.thursday:
      return Weekday.thursday;
    case DateTime.friday:
      return Weekday.friday;
    case DateTime.saturday:
      return Weekday.saturday;
    case DateTime.sunday:
    default:
      return Weekday.sunday;
  }
}

DateTime startOfWeek(DateTime date) {
  final difference = date.weekday - DateTime.monday;
  final normalized = DateTime(date.year, date.month, date.day);
  return normalized.subtract(Duration(days: difference < 0 ? 6 : difference));
}

String monthKey(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';
}

bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

extension WeekdayLocalization on Weekday {
  String localizedName({required String Function(String) t}) {
    switch (this) {
      case Weekday.monday:
        return t('monday');
      case Weekday.tuesday:
        return t('tuesday');
      case Weekday.wednesday:
        return t('wednesday');
      case Weekday.thursday:
        return t('thursday');
      case Weekday.friday:
        return t('friday');
      case Weekday.saturday:
        return t('saturday');
      case Weekday.sunday:
        return t('sunday');
    }
  }
}

