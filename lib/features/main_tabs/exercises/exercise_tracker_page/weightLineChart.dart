import 'package:fitpill/core/models/chartData_model.dart';
import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/user_exercise_provider.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'time_range/time_range_buttons.dart';
import 'time_range/time_range_provider.dart';
import 'dart:math';

class WeightLineChart extends ConsumerStatefulWidget {
  final String exerciseName;

  const WeightLineChart({super.key, required this.exerciseName});

  @override
  ConsumerState<WeightLineChart> createState() => _WeightLineChartState();
}

class _WeightLineChartState extends ConsumerState<WeightLineChart>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final selectedRange = ref.watch(selectedRangeProvider);

    final chartDataAsync = ref.watch(
      weightChartDataProvider(
        (exerciseId: widget.exerciseName, range: selectedRange),
      ),
    );

    return SafeArea(
      child: chartDataAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: ThemeHelper.getFitPillColor(context),
          ),
        ),
        error: (e, _) => Center(child: Text('${S.of(context)!.error} : $e')),
        data: (data) {

          final points = data
              .whereType<ChartData>()                     // data List<ChartData?> ise güvence
              .where((d) => d.date != null)
              .toList();

          if (data.length < 2) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    S.of(context)!.weightTrackingChart,
                  ),
                ),
                Center(child: Text(S.of(context)!.addAtLeast2)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      color: ThemeHelper.isDarkTheme(context)
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      elevation: 0,
                      child: const TimeRangeRow(),
                    ),
                  ),
                ),
              ],
            );
          }

          final values = points.map((d) => d.value.toDouble()).toList();

          final minYData = values.reduce(min); // dart:math min
          final maxYData = values.reduce(max);
          double roundDown5(double value) => (value / 5).floorToDouble() * 5;
          double roundUp5(double value) => (value / 5).ceilToDouble() * 5;
          double roundDown2_5(double value) =>
              (value / 2.5).floorToDouble() * 2.5;
          double roundUp2_5(double value) => (value / 2.5).ceilToDouble() * 2.5;

          late double minY;
          late double maxY;
          late double interval;

          if (maxYData >= 50) {
            minY = roundDown5(minYData);
            maxY = roundUp5(maxYData);

            if (minY == minYData) minY -= 5;
            if (maxY == maxYData) maxY += 5;

            final raw = ((maxY - minY) / 4).ceilToDouble();

            // 5’in katına YUKARI yuvarla ve alt sınır ver
            double roundUpTo5(double v) => (v <= 0)
                ? 5
                : ((v % 5 == 0) ? v : ((v / 5).ceil() * 5).toDouble());
            interval = roundUpTo5(raw);

            maxY = minY + interval * 4; // eksene oturt
          } else {
            minY = roundDown2_5(minYData);
            maxY = roundUp2_5(maxYData);

            if (minY == minYData) minY -= 2.5;
            if (maxY == maxYData) maxY += 2.5;

            final candidate = (maxY - minY) / 4;
            interval = candidate < 2.5 ? (maxY - minY) / 2 : candidate;

            // Güvenlik: 0 olmasın
            if (interval <= 0) interval = 2.5;

            // İstersen 2.5’in katına yuvarlayabilirsin:
            double roundUpTo2_5(double v) =>
                (v <= 0) ? 2.5 : ((v / 2.5).ceil() * 2.5);
            interval = roundUpTo2_5(interval);

            maxY = minY + interval * 4;
          }

// Son güvenlik
          if (maxY <= minY) {
            maxY = minY + (maxYData >= 50 ? 20 : 10);
            interval = (maxY - minY) / 4;
          }

          return Column(
            children: [
              Text(
                S.of(context)!.weight,
                style: const TextStyle(fontSize: 16),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
                  child: SfCartesianChart(
                    margin: EdgeInsets.zero,
                    plotAreaBorderWidth: 0,
                    primaryXAxis: DateTimeAxis(
                      plotOffset: 20,
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(size: 0),
                      majorGridLines: const MajorGridLines(width: 0),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      intervalType: DateTimeIntervalType.days,
                      dateFormat: DateFormat('d/MM'),
                      labelStyle: TextStyle(
                        fontSize: 10,
                        color: ThemeHelper.getTextColor(context).withAlpha(100),
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      plotOffset: 5,
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(size: 0),
                      minimum: minY,
                      maximum: maxY,
                      interval: interval,
                      anchorRangeToVisiblePoints: false,
                      majorGridLines: const MajorGridLines(width: 0),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.getTextColor(context).withAlpha(100),
                      ),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: false),
                    zoomPanBehavior: ZoomPanBehavior(enablePanning: false),
                    series: <CartesianSeries<ChartData, DateTime>>[
                      LineSeries<ChartData, DateTime>(
                        dataSource: data,
                        xValueMapper: (ChartData d, _) => d.date,
                        yValueMapper: (ChartData d, _) => d.value,
                        color: ThemeHelper.getFitPillColor(context),
                        width: 2.25,
                        markerSettings: const MarkerSettings(isVisible: false),
                      )
                    ],
                  ),
                ),
              ),

              /// grafiğin başlangıç tarihini seçme yeri 1M, 3M, 6M, 1Y, ALL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  color: ThemeHelper.isDarkTheme(context)
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  elevation: 0,
                  child: const TimeRangeRow(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
