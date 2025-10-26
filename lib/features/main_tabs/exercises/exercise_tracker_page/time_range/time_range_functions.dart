import 'package:flutter/material.dart';

import 'time_range_provider.dart';

DateTimeRange? rangeFor(TimeRange r) {
  final now = DateTime.now();
  switch (r) {
    case TimeRange.m1:
      return DateTimeRange(
          start: DateTime(now.year, now.month - 1, now.day), end: now);
    case TimeRange.m3:
      return DateTimeRange(
          start: DateTime(now.year, now.month - 3, now.day), end: now);
    case TimeRange.m6:
      return DateTimeRange(
          start: DateTime(now.year, now.month - 6, now.day), end: now);
    case TimeRange.y1:
      return DateTimeRange(
          start: DateTime(now.year - 1, now.month, now.day), end: now);
    case TimeRange.all:
      return null; // tüm zaman
  }
}
