import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/snackbar_helper.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/features/main_tabs/progress/measurement_metrics.dart';
import 'package:fitpill/features/main_tabs/progress/progress_provider.dart' as progress;
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:fitpill/core/system/config/theme/theme_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fullscreen_graphpage.dart';
import 'measurement_selectiontohomepage.dart';

class MeasurementMiniGraphCard extends ConsumerWidget {
  const MeasurementMiniGraphCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkTheme = themeMode == ThemeMode.dark;

    final selectedMetricAsync = ref.watch(progress.favoriteMetricProvider);

    return selectedMetricAsync.when(
      loading: () => const AppSectionShimmer(
        height: 130,
        margin: EdgeInsets.symmetric(horizontal: 16),
      ),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (metric) {
        if (metric == null) {
          return const Center(child: Text("Gösterilecek metrik yok"));
        }
        final graphAsync = ref.watch(progress.graphDataProvider(metric));

        return graphAsync.when(
          loading: () => const AppSectionShimmer(
            height: 130,
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
          error: (e, _) => Center(child: Text('Hata: $e')),
          data: (chartData) {
            if (chartData.isEmpty) {
              return _buildEmptyCard(context, metric);
            }

            final last7 = chartData.length <= 7
                ? chartData
                : chartData.sublist(chartData.length - 7);

            final latestValue = last7.isNotEmpty ? last7.last.value : 0;

            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MeasurementSelectionPage(),
                  ),
                );
                ref.invalidate(progress.graphDataProvider((metric)));
              },
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    height: 130,
                    decoration: BoxDecoration(
                      color: ThemeHelper.getCardColor(context),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeHelper.isDarkTheme(context)
                              ? Colors.black54
                              : Colors.grey.shade400,
                          blurRadius: 3,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getMetricName(context, metric).toUpperCase(),
                                style: GoogleFonts.tomorrow(
                                  fontSize: 14,
                                  color: ThemeHelper.getTextColor(context)
                                      .withValues(alpha:0.5),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatDouble(latestValue.toDouble()),
                                style: GoogleFonts.tomorrow(
                                  fontSize: 34,
                                  color: ThemeHelper.getTextColor(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                getMetricUnit(metric).toUpperCase(),
                                style: GoogleFonts.tomorrow(
                                  fontSize: 16,
                                  color: ThemeHelper.getTextColor(context)
                                      .withValues(alpha:0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (chartData.length >= 2)
                          Flexible(
                            flex: 2,
                            child: SizedBox(
                              height: 37,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: LineChart(
                                  LineChartData(
                                    gridData: const FlGridData(show: false),
                                    titlesData: const FlTitlesData(show: false),
                                    borderData: FlBorderData(show: false),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: List.generate(
                                          last7.length,
                                          (index) => FlSpot(index.toDouble(),
                                              last7[index].value),
                                        ),
                                        isCurved: false,
                                        color: isDarkTheme
                                            ? Colors.orange
                                            : const Color(0xFF0D47A1),
                                        barWidth: 2,
                                        dotData: FlDotData(
                                          show: true,
                                          getDotPainter: (spot, _, __, ___) {
                                            return FlDotCirclePainter(
                                              radius: 3,
                                              color: isDarkTheme
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
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 15,
                    child: IconButton(
                      onPressed: () {
                        if (chartData.length < 2) {
                          SnackbarHelper.show(
                            context,
                            message: 'Grafik için en az 2 veri girmelisiniz.',
                            icon: Icons.info,
                            backgroundColor: Colors.orangeAccent,
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FullScreenGraphPage(metric: metric),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.fullscreen,
                        size: 26,
                        color: ThemeHelper.getTextColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyCard(BuildContext context, metric) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MeasurementSelectionPage(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeHelper.getCardColor(context),
          borderRadius: BorderRadius.circular(16),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getMetricName(context, metric).toUpperCase(),
                  style: GoogleFonts.tomorrow(
                    fontSize: 16,
                    color: ThemeHelper.getTextColor(context).withValues(alpha:0.5),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  S.of(context)!.noData,
                  style: GoogleFonts.tomorrow(
                    fontSize: 34,
                    color: ThemeHelper.getTextColor(context),
                  ),
                ),
                Text(
                  getMetricUnit(metric).toUpperCase(),
                  style: GoogleFonts.tomorrow(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeHelper.getTextColor(context).withValues(alpha:0.5),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                SnackbarHelper.show(
                  context,
                  message: 'Grafik için en az 2 veri girmelisiniz.',
                  icon: Icons.info,
                  backgroundColor: Colors.orangeAccent,
                );
              },
              icon: const Icon(Icons.touch_app_outlined,
                  size: 30, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String formatDouble(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(1);
    }
  }
}
