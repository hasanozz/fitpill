import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'muscle_region.dart';

enum AnatomySide { front, back }

class AnatomyRepository {
  final Map<AnatomySide, String> _assetMap = const {
    AnatomySide.front: 'assets/json/anatomy_front.json',
    AnatomySide.back: 'assets/json/anatomy_back.json',
  };

  Future<List<MuscleRegion>> loadRegions(AnatomySide side) async {
    final jsonStr = await rootBundle.loadString(_assetMap[side]!);
    final data = json.decode(jsonStr) as Map<String, dynamic>;
    final viewBox = data['viewBox'] as Map<String, dynamic>;
    final regions = (data['regions'] as List).cast<Map<String, dynamic>>();

    // viewBox bilgisini her region’a enjekte ediyoruz (parse kolaylığı)
    final enriched = regions
        .map((r) => {
              ...r,
              '__viewBox__': viewBox,
            })
        .toList();

    return enriched.map((e) => MuscleRegion.fromJson(e)).toList();
  }

  String svgAssetOf(AnatomySide side) {
    return side == AnatomySide.front
        ? 'assets/images/anatomifront.svg'
        : 'assets/images/anatomiback.svg';
  }
}
