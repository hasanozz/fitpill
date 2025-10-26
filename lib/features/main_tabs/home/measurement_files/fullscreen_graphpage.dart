import 'package:fitpill/core/models/chartData_model.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/features/main_tabs/progress/progress_provider.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FullScreenGraphPage extends ConsumerWidget {
  final String metric;

  const FullScreenGraphPage({
    super.key,
    required this.metric,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartDataAsync = ref.watch(graphDataProvider(metric));

    return Scaffold(
      appBar: AppBar(
        title: Text(metric.toUpperCase()),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.fullscreen_exit, size: 30),
          ),
        ],
      ),
      body: chartDataAsync.when(
        loading: () => const AppPageShimmer(
          padding: EdgeInsets.all(16),
          itemHeight: 220,
        ),
        error: (e, st) => const Center(child: Text("Bir hata oluştu")),
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text("Veri bulunamadı."));
          }

          final minY = data.map((e) => e?.value).reduce((a, b) => a! < b! ? a : b);
          final maxY = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
          final yMin = (minY! * 0.990).floorToDouble();
          final yMax = (maxY * 1.010).ceilToDouble();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SfCartesianChart(
              plotAreaBorderWidth: 1,
              primaryXAxis: DateTimeAxis(
                interval: 7,
                dateFormat: DateFormat('dd MMM'),
                intervalType: DateTimeIntervalType.days,
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                labelRotation: 270,
                majorGridLines: MajorGridLines(
                    width: 0.5,
                    color: ThemeHelper.isDarkTheme(context)
                        ? Colors.white24
                        : Colors.black26),
              ),
              primaryYAxis: NumericAxis(
                minimum: yMin,
                maximum: yMax,
                majorGridLines:
                    const MajorGridLines(width: 0.5, color: Colors.white24),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                canShowMarker: true,
                activationMode: ActivationMode.singleTap,
                tooltipPosition: TooltipPosition.auto,
                animationDuration: 200,
                format: 'point.x : point.y',
                header: metric,
                borderColor: ThemeHelper.isDarkTheme(context)
                    ? Colors.orange
                    : const Color(0xFF0D47A1),
                color: Colors.white,
                textStyle: const TextStyle(color: Colors.black),
              ),
              series: <CartesianSeries<ChartData, DateTime>>[
                LineSeries<ChartData, DateTime>(
                  dataSource: data,
                  xValueMapper: (ChartData d, _) => d.date,
                  yValueMapper: (ChartData d, _) => d.value,
                  color: ThemeHelper.isDarkTheme(context)
                      ? Colors.orange
                      : const Color(0xFF0D47A1),
                  width: 2,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    borderWidth: 1.5,
                    width: 8,
                    height: 8,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
