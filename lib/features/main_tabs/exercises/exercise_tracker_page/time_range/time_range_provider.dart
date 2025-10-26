import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod/legacy.dart';

enum TimeRange { m1, m3, m6, y1, all }

extension TimeRangeLabel on TimeRange {
  String get label {
    switch (this) {
      case TimeRange.m1:
        return '1M';
      case TimeRange.m3:
        return '3M';
      case TimeRange.m6:
        return '6M';
      case TimeRange.y1:
        return '1Y';
      case TimeRange.all:
        return 'All';
    }
  }
}

// ----------------------------------------------------
// Hata veren StateProvider kaldırıldı ve yerine Notifier getirildi.
// Riverpod 3.0.3'te basit durum yönetimi için önerilen ideal yapı budur.
// ----------------------------------------------------

/// TimeRange değerini yöneten Notifier sınıfı.
class SelectedRangeNotifier extends Notifier<TimeRange> {
  // Notifier'ın başlangıç değerini tanımlar.
  @override
  TimeRange build() {
    return TimeRange.all;
  }

  /// Seçili zaman aralığını güncelleyen metot.
  void selectRange(TimeRange newRange) {
    state = newRange;
  }
}

/// UI'dan izlenecek ve komut gönderilecek Provider tanımı.
final selectedRangeProvider = NotifierProvider<SelectedRangeNotifier, TimeRange>(
  SelectedRangeNotifier.new,
);
