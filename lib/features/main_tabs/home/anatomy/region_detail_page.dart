// pages/region_detail_page.dart
import 'muscle_region.dart';
import 'package:flutter/material.dart';

class RegionDetailPage extends StatelessWidget {
  final MuscleRegion region;

  const RegionDetailPage({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(region.name)),
      body: Center(
        child: Text('Region: ${region.name}'),
      ),
    );
  }
}
