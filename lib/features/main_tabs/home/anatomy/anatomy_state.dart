// providers/anatomy_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'anatomy_providers.dart';
import 'anatomy_repository.dart';
import 'geometry.dart';
import 'mapping.dart';
import 'muscle_region.dart';

/// ---- Provider ----
/// NotifierProvider, Riverpod 3.x'te StateNotifierProvider yerine kullanılır.
/// Dışarıdan constructor parametresi verilmez; bağımlılıklar `ref.read(...)` ile alınır.
final anatomyProvider =
NotifierProvider<AnatomyNotifier, AnatomyState>(AnatomyNotifier.new);

/// ---- State ----
class AnatomyState {
  final AnatomySide side;
  final AsyncValue<List<MuscleRegion>> regions;
  final String? flashRegionId; // 180ms highlight

  const AnatomyState({
    required this.side,
    required this.regions,
    this.flashRegionId,
  });

  AnatomyState copyWith({
    AnatomySide? side,
    AsyncValue<List<MuscleRegion>>? regions,
    String? flashRegionId,
  }) {
    return AnatomyState(
      side: side ?? this.side,
      regions: regions ?? this.regions,
      flashRegionId: flashRegionId,
    );
  }
}

/// ---- Notifier (Riverpod 3.x) ----
/// Önceden: class AnatomyNotifier extends StateNotifier<AnatomyState>
/// Şimdi:   class AnatomyNotifier extends Notifier<AnatomyState>
/// - İlk state `build()` içinde verilir.
/// - Async işler `build()` sonrasında tetiklenir (microtask) veya methodlarla yapılır.
class AnatomyNotifier extends Notifier<AnatomyState> {
  /// Repo'ya constructor ile değil, ref.read ile erişeceğiz.
  AnatomyRepository get _repo => ref.read(anatomyRepositoryProvider);

  @override
  AnatomyState build() {
    // 1) İlk state: ön yüz + yükleniyor
    final initial = const AnatomyState(
      side: AnatomySide.front,
      regions: AsyncLoading(),
    );

    // 2) build() senkron olmalı; ilk state'i döndürürüz,
    //    ardından microtask ile _load() çağırıp regions'ı doldururuz.
    Future.microtask(_load);

    return initial;
  }

  /// JSON'dan bölgeleri çekip state.regions'ı doldurur.
  Future<void> _load() async {
    try {
      final list = await _repo.loadRegions(state.side);
      state = state.copyWith(regions: AsyncData(list));
    } catch (e, st) {
      state = state.copyWith(regions: AsyncError(e, st));
    }
  }

  /// Ön/arka yüzü değiştirir ve tekrar yükler.
  Future<void> toggleSide() async {
    final newSide =
    state.side == AnatomySide.front ? AnatomySide.back : AnatomySide.front;

    // Yüz değişince önce loading'e al
    state = AnatomyState(side: newSide, regions: const AsyncLoading());

    // Sonra veriyi çek
    await _load();
  }

  /// ID üzerinden region bulur (yoksa null).
  MuscleRegion? regionById(String id) {
    final list = state.regions.asData?.value;
    if (list == null) return null;
    for (final r in list) {
      if (r.id == id) return r;
    }
    return null;
  }

  /// UI: onTapDown -> local position + widget size
  /// Hit test, viewBox'a map, polygon testleri ve kısa "flash" efekti.
  Future<String?> onTap(Offset localPos, Size widgetSize) async {
    final regions = state.regions.asData?.value;
    if (regions == null || regions.isEmpty) return null;

    // Tüm region'ların viewBox'ı aynı JSON'dan geldiği için ilkini referans al
    final viewBox = regions.first.viewBox;

    // Widget koordinatından SVG viewBox koordinatına dönüşüm
    final p = HitMapping.widgetToViewBox(
      localTap: localPos,
      widgetSize: widgetSize,
      viewBoxOrViewport: viewBox,
    );

    String? hitId;

    // Basit bounding box ile hızlı eleme + ray casting (pointInPolygon)
    for (final r in regions) {
      final bounds = r.groupBounds(); // List<Rect>
      final groups = r.pointGroups;   // List<List<Offset>>

      for (int gi = 0; gi < groups.length; gi++) {
        if (!bounds[gi].contains(p)) continue;       // hızlı eleme
        if (pointInPolygon(p, groups[gi])) {         // kesin test
          hitId = r.id; // aynı id'ye ait tüm grupları flash'la
          break;
        }
      }
      if (hitId != null) break;
    }

    // 180ms flash efekti
    if (hitId != null) {
      state = state.copyWith(flashRegionId: hitId);
      await Future.delayed(const Duration(milliseconds: 180));
      // Eğer bu arada yüz değiştiyse flashRegionId'yi sıfırlamak yine güvenli
      state = state.copyWith(flashRegionId: null);
    }

    return hitId;
  }
}
