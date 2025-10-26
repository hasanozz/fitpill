import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui//widgets/app_schimmer.dart';
import 'weekly_routine_models.dart';
import 'weekly_routine_provider.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class WeeklyRoutineAnalyticsCard extends ConsumerWidget {
  const WeeklyRoutineAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyRoutineAsync = ref.watch(weeklyRoutineProvider);

    return weeklyRoutineAsync.when(
      data: (state) => _AnalyticsContent(analytics: state.analytics),
      loading: () => const AppSectionShimmer(
        height: 150,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      error: (_, __) => const _AnalyticsError(),
    );
  }
}

class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent({required this.analytics});

  final WeeklyRoutineAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final isDarkTheme = ThemeHelper.isDarkTheme(context);
    final accent = ThemeHelper.getFitPillColor(context);
    const textColor = Colors.white;

    final thisMonthKey = analytics.activeMonthKey;
    final thisMonthCount = analytics.totalForMonth(thisMonthKey);
    final thisMonthLabel = _formatMonthLabel(context, thisMonthKey);

    final historyKeys = analytics.monthlyTotals.keys
        .where((key) => key != thisMonthKey)
        .toList()
      ..sort();
    final previousMonthKey = historyKeys.isEmpty ? null : historyKeys.last;
    final previousMonthCount = previousMonthKey == null
        ? null
        : analytics.totalForMonth(previousMonthKey);
    final previousMonthLabel = previousMonthKey == null
        ? null
        : _formatMonthLabel(context, previousMonthKey);

    final gradientColors = isDarkTheme
        ? [
            accent.withValues(alpha: 0.55),
            accent.withValues(alpha: 0.3),
          ]
        : [
            accent,
            accent.withValues(alpha: 0.8),
          ];

    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDarkTheme ? 0.4 : 0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.auto_graph,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n!.weeklyRoutineAnalyticsCardTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.tomorrow(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.weeklyRoutineAnalyticsThisMonth(
                      thisMonthLabel,
                      thisMonthCount,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.95),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (previousMonthLabel != null)
                    Text(
                      l10n.weeklyRoutineAnalyticsLastMonth(
                        previousMonthLabel,
                        previousMonthCount ?? 0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    )
                  else
                    Text(
                      l10n.weeklyRoutineAnalyticsEmpty,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.75),
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalyticsError extends StatelessWidget {
  const _AnalyticsError();

  @override
  Widget build(BuildContext context) {
    final accent = ThemeHelper.getFitPillColor(context);

    return SizedBox(
      height: 150,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeHelper.getCardColor(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: accent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                S.of(context)!.weeklyRoutineAnalyticsEmpty,
                style: GoogleFonts.tomorrow(
                  color: ThemeHelper.getTextColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatMonthLabel(BuildContext context, String monthKey) {
  final parts = monthKey.split('-');
  if (parts.length != 2) {
    return monthKey;
  }
  final year = int.tryParse(parts[0]) ?? DateTime.now().year;
  final month = int.tryParse(parts[1]) ?? DateTime.now().month;
  final date = DateTime(year, month);
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.MMMM(locale).format(date);
}
