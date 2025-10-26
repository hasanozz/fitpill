import 'package:fitpill/core/ui/dialogs/snackbar_helper.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/features/main_tabs/home/measurement_files/fullscreen_graphpage.dart';
import 'package:fitpill/features/main_tabs/progress/measurement_metrics.dart';
import 'package:fitpill/features/main_tabs/progress/progress_provider.dart';
import 'package:fitpill/features/main_tabs/progress/progress_repository.dart';
import 'package:fitpill/features/auth/auth_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';

class MeasurementSelectionPage extends ConsumerWidget {
  const MeasurementSelectionPage({super.key});

  String formatDouble(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString(); // Tam sayıysa .0 atılır
    } else {
      return value.toStringAsFixed(1); // Ondalık varsa 1 basamak göster
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDataAsync = ref.watch(allProgressDataProvider);
    final selectedMetric = ref.watch(selectedMetricProvider);

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        title: selectedMetric != null
            ? Text(getMetricName(context, selectedMetric).toUpperCase())
            : Text(S.of(context)!.metrics),
        backgroundColor: ThemeHelper.getBackgroundColor(context),
      ),
      body: allDataAsync.when(
        loading: () => const AppPageShimmer(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          itemHeight: 125,
        ),
        error: (e, st) => Center(
          child: Text(S.of(context)!.error),
        ),
        data: (dataMap) {
          return ListView.builder(
            itemCount: metrics.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final metric = metrics[index];
              final chartData = dataMap[metric] ?? [];
              final last7 = chartData.length <= 7
                  ? chartData
                  : chartData.sublist(chartData.length - 7);
              final hasData = chartData.isNotEmpty;
              final latest = hasData ? last7.last.value : null;

              return GestureDetector(
                onTap: () async {
                  ref.read(selectedMetricProvider.notifier).state = metric;
                  final userId = ref.watch(userIdProvider);
                  final repo = ProgressRepository(userId: userId!);
                  await repo.saveFavoriteMetric(metric);
                  ref.invalidate(favoriteMetricProvider);
                },
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      height: 125,
                      decoration: BoxDecoration(
                        color: ThemeHelper.getCardColor(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: selectedMetric == metric
                                ? ThemeHelper.isDarkTheme(context)
                                    ? Colors.orange
                                    : const Color(0xFF0D47A1)
                                : Colors.transparent,
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: ThemeHelper.isDarkTheme(context)
                                ? Colors.black54
                                : Colors.grey,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Sol
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getMetricName(context, metric).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeHelper.getTextColor(context)
                                      .withAlpha((255 * 0.5).toInt()),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                hasData
                                    ? formatDouble(latest!)
                                    : S.of(context)!.noData,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeHelper.getTextColor(context),
                                ),
                              ),
                              Text(
                                getMetricUnit(metric).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeHelper.getTextColor(context)
                                      .withAlpha(128),
                                ),
                              ),
                            ],
                          ),

                          // Sparkline
                          if (chartData.length >= 2)
                            SizedBox(
                              width: 150,
                              height: 20,
                              child: LineChart(
                                LineChartData(
                                  gridData: const FlGridData(show: false),
                                  titlesData: const FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: List.generate(
                                        last7.length,
                                        (i) => FlSpot(
                                            i.toDouble(), last7[i].value),
                                      ),
                                      isCurved: false,
                                      color: ThemeHelper.isDarkTheme(context)
                                          ? Colors.orange
                                          : const Color(0xFF0D47A1),
                                      barWidth: 2,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, barData, index) {
                                          return FlDotCirclePainter(
                                            radius: 3,
                                            color:
                                                ThemeHelper.isDarkTheme(context)
                                                    ? Colors.orange
                                                    : const Color(0xFF0D47A1),
                                            strokeWidth: 0,
                                          );
                                        },
                                      ),
                                      belowBarData: BarAreaData(show: false),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 24,
                      top: 8,
                      child: IconButton(
                        icon: Icon(Icons.fullscreen,
                            size: 26, color: ThemeHelper.getTextColor(context)),
                        onPressed: () {
                          if (chartData.length < 2) {
                            SnackbarHelper.show(
                              context,
                              message: 'En az iki veri girmelisiniz.',
                              icon: Icons.info,
                              backgroundColor: ThemeHelper.isDarkTheme(context)
                                  ? Colors.orangeAccent
                                  : const Color(0xFF0D47A1),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullScreenGraphPage(
                                  metric: metric,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
