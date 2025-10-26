import 'dart:math' as math;

import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';
import 'package:fitpill/features/main_tabs/progress//measurement_metrics.dart';
import 'package:fitpill/features/main_tabs/progress/progress_functions.dart';
import 'package:fitpill/features/main_tabs/progress/progress_goal_model.dart';
import 'package:fitpill/features/main_tabs/progress/progress_goals_provider.dart';
import 'package:fitpill/features/main_tabs/progress/progress_history.dart';
import 'package:fitpill/features/main_tabs/progress/progress_model.dart';
import 'package:fitpill/features/main_tabs/progress/progress_provider.dart';
import 'package:fitpill/core/ui/dialogs/premium_upgrade_overlay.dart';
import 'package:fitpill/core/ui/dialogs/snackbar_helper.dart';
import 'package:fitpill/core/ui//widgets/app_schimmer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';

const Map<String, IconData> _metricIcons = {
  'weight': Icons.monitor_weight_outlined,
  'shoulder': Icons.accessibility_new_outlined,
  'chest': Icons.fitness_center_outlined,
  'waist': Icons.straighten,
  'hip': Icons.donut_small,
  'leg': Icons.directions_run,
  'arm': Icons.sports_martial_arts,
  'calf': Icons.directions_walk,
  'neck': Icons.accessibility,
  bodyFatMetricKey: Icons.percent_outlined,
  leanMassMetricKey: Icons.fitness_center,
  ffmiMetricKey: Icons.speed_outlined,
  bmiMetricKey: Icons.monitor_weight,
};



class ProgressPage extends ConsumerStatefulWidget {
  const ProgressPage({super.key});

  @override
  ConsumerState<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends ConsumerState<ProgressPage> {
  String? expandedMetric;
  final Map<String, TextEditingController> _controllers = {};

  final Map<String, GlobalKey> _expansionTileKeys = {};
  final PageController _highlightController =
      PageController(viewportFraction: 0.88);
  int _highlightIndex = 0;

  @override
  void initState() {
    super.initState();
    for (String metric in metrics) {
      if (!autoTrackedMetrics.contains(metric)) {
        _controllers[metric] = TextEditingController();
      }
      _expansionTileKeys[metric] =
          GlobalKey(); // Her metric için GlobalKey oluştur
    }
  }

  @override
  void dispose() {
    _highlightController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premiumStatus = ref.watch(premiumStatusProvider);
    final profileState = ref.watch(profileProvider);
    final goalsState = ref.watch(progressGoalsProvider);
    final bool isPremium = premiumStatus.maybeWhen(
      data: (value) => value,
      orElse: () => false,
    );
    final bool isPremiumLoading =
        premiumStatus.isLoading || profileState.isLoading;

    if (isPremiumLoading) {
      return Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        body: const AppPageShimmer(padding: EdgeInsets.all(16)),
      );
    }

    if (premiumStatus.hasError || profileState.hasError) {

      if (profileState.hasError) {
        debugPrint('Profil Provider Hatası: ${profileState.error}');
        // Stack trace'i görmek için:
        debugPrint('Profile Stack Trace: ${profileState.stackTrace}');
      }
      return Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        body: Center(
          child: Text(
            S.of(context)!.anErrorOccurred,
            textAlign: TextAlign.center,
            style: TextStyle(color: ThemeHelper.getTextColor(context)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: _buildMeasurementsTab(
          context,
          isPremium,
          isPremiumLoading,
          goalsState,
        ),
      ),
    );
  }

  Widget _buildMeasurementsTab(
    BuildContext context,

    bool isPremium,
    bool isPremiumLoading,
    AsyncValue<List<ProgressGoal>> goalsState,
  ) {
    final goals = goalsState.value ?? const <ProgressGoal>[];
    final activeGoals = goals.where((goal) => !goal.isCompleted).toList();
    final isGoalLoading = goalsState.isLoading;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 120),
      physics: const BouncingScrollPhysics(),
      itemCount: metrics.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHighlightSection(context, activeGoals);
        }

        final metric = metrics[index - 1];
        final metricGoals = goals
            .where((goal) => goal.metric == metric && !goal.isCompleted)
            .toList();
        final isAutoTrackedMetric = autoTrackedMetrics.contains(metric);
        final latestMeasurementAsync = ref.watch(
          latestMeasurementProvider(metric),
        );
        final leanMassCompanionAsync = isAutoTrackedMetric && metric == ffmiMetricKey
            ? ref.watch(latestMeasurementProvider(leanMassMetricKey))
            : null;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Card(
            color: ThemeHelper.getCardColor(context),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            shadowColor: Colors.black.withAlpha((255 * 0.2).toInt()),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  iconColor: Colors.black87,
                ),
              ),
              child: ExpansionTile(
                key: _expansionTileKeys[metric],
                initiallyExpanded: expandedMetric == metric,
                onExpansionChanged: (expanded) {
                  setState(() {
                    if (expanded) {
                      expandedMetric = metric;
                      for (var key in _expansionTileKeys.keys) {
                        if (key != metric) {
                          _expansionTileKeys[key] = GlobalKey();
                        }
                      }
                    } else {
                      expandedMetric = null;
                    }
                  });
                },
                title: Row(
                  children: [
                    Icon(
                      _metricIcons[metric] ?? Icons.bar_chart,
                      color: ThemeHelper.getFitPillColor(context),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        getMetricName(context, metric),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: expandedMetric == metric
                              ? ThemeHelper.getFitPillColor(context)
                              : ThemeHelper.getTextColor(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _MetricLatestValueBadge(
                      metric: metric,
                      latestMeasurementAsync: latestMeasurementAsync,
                    ),
                  ],
                ),
                trailing: AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: expandedMetric == metric ? 0.25 : 0.0,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: expandedMetric == metric
                        ? ThemeHelper.getFitPillColor(context)
                        : ThemeHelper.getTextColor(context),
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withAlpha((255 * 0.05).toInt()),
                      borderRadius:
                          const BorderRadius.vertical(bottom: Radius.circular(15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isAutoTrackedMetric)
                          _buildAutoTrackedMetricSection(
                            context,
                            metric,
                            latestMeasurementAsync,
                            leanMassCompanionAsync,
                          )
                        else ...[
                          TextField(
                            cursorColor: ThemeHelper.getTextColor(context),
                            controller: _controllers[metric],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*$'),
                              ),
                            ],
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ThemeHelper.isDarkTheme(context)
                                      ? Colors.orange
                                      : const Color(0xFF0D47A1),
                                  width: 2,
                                ),
                              ),
                              labelText:
                                  '${getMetricName(context, metric)} ${S.of(context)!.value}',
                              suffixText: getMetricUnit(metric),
                              labelStyle: TextStyle(
                                color:
                                    Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade300
                                        : Colors.black54,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor:
                                  Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade800
                                      : Colors.white,
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isPremiumLoading
                                  ? null
                                  : () {
                                      final inputValue =
                                          _controllers[metric]!.text.trim();
                                      final errorMessage =
                                          validateInput(inputValue, metric, context);

                                      if (!isPremium) {
                                        showPremiumUpgradeOverlay(context);
                                        return;
                                      }

                                      if (errorMessage != null) {
                                        SnackbarHelper.show(
                                          context,
                                          message: errorMessage,
                                          backgroundColor: Colors.red,
                                        );
                                        return;
                                      }

                                      final value = double.parse(
                                        inputValue.replaceAll(',', '.'),
                                      );
                                      ref
                                          .read(progressProvider.notifier)
                                          .save(metric, value);
                                      ref
                                          .invalidate(progressHistoryProvider(metric));
                                      ref.invalidate(allProgressDataProvider);
                                      ref.invalidate(graphDataProvider);

                                      setState(() {
                                        _controllers[metric]!.clear();
                                        SnackbarHelper.show(
                                          context,
                                          message: S.of(context)!.successfullySaved,
                                          backgroundColor: Colors.green,
                                        );
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: isPremium
                                    ? ThemeHelper.isDarkTheme(context)
                                        ? Colors.orange
                                        : const Color(0xFF0D47A1)
                                    : Colors.grey,
                                disabledBackgroundColor: Colors.grey.shade400,
                              ),
                              child: Text(
                                S.of(context)!.save,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeHelper.getBackgroundColor(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (metricGoals.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          for (final goal in metricGoals)
                            _buildMetricGoalSummary(context, goal),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProgressHistoryPage(
                                      metric: metric,
                                    ),
                                  ),
                                ),
                                icon: const Icon(Icons.history),
                                label: Text(S.of(context)!.history),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: (!isPremium || isGoalLoading)
                                    ? (!isPremium
                                        ? () =>
                                            showPremiumUpgradeOverlay(context)
                                        : null)
                                    : () {
                                        final goalToEdit = metricGoals.isNotEmpty
                                            ? metricGoals.first
                                            : null;
                                        _showGoalSheet(
                                          context,
                                          initialMetric: metric,
                                          existingGoal: goalToEdit,
                                        );
                                      },
                                icon: Icon(
                                  metricGoals.isNotEmpty
                                      ? Icons.edit_outlined
                                      : Icons.flag_outlined,
                                ),
                                label: Text(
                                  metricGoals.isNotEmpty
                                      ? S.of(context)!.goalEditFromMetric
                                      : S.of(context)!.goalCreateFromMetric,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHighlightSection(
    BuildContext context,
    List<ProgressGoal> goals,
  ) {
    final configs = _highlightMetricConfigs(context);
    if (configs.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDarkTheme = ThemeHelper.isDarkTheme(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: PageView.builder(
              controller: _highlightController,
              itemCount: configs.length,
              onPageChanged: (index) {
                setState(() {
                  _highlightIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final config = configs[index];
                final goal = _goalForMetric(goals, config.metric);
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 8,
                    right: index == configs.length - 1 ? 0 : 8,
                  ),
                  child: _HighlightMetricCard(
                    config: config,
                    goal: goal,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(configs.length, (index) {
              final isActive = _highlightIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: isActive ? 24 : 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? (isDarkTheme ? Colors.orange : const Color(0xFF0D47A1))
                      : ThemeHelper.getTextColor(context)
                          .withValues(alpha:0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  List<_HighlightMetricConfig> _highlightMetricConfigs(BuildContext context) {
    return [
      _HighlightMetricConfig(
        metric: 'weight',
        labelBuilder: (ctx) => getMetricName(ctx, 'weight'),
        unit: getMetricUnit('weight'),
        fractionDigits: 1,
      ),
      _HighlightMetricConfig(
        metric: bodyFatMetricKey,
        labelBuilder: (ctx) => S.of(ctx)!.bodyFatPercentage,
        unit: '%',
        fractionDigits: 1,
      ),
      _HighlightMetricConfig(
        metric: leanMassMetricKey,
        labelBuilder: (ctx) => S.of(ctx)!.leanMass,
        unit: 'kg',
        fractionDigits: 1,
      ),
    ];
  }

  Widget _buildAutoTrackedMetricSection(
    BuildContext context,
    String metric,
    AsyncValue<ProgressModel?> latestAsync,
    AsyncValue<ProgressModel?>? leanMassAsync,
  ) {
    final textColor = ThemeHelper.getTextColor(context);
    final localeTag = Localizations.localeOf(context).toLanguageTag();

    return latestAsync.when(
      data: (latest) {
        final unit = getMetricUnit(metric);
        final latestValue = latest?.value;
        final formattedValue = latestValue != null
            ? '${_formatValue(latestValue)}${unit.isNotEmpty ? ' $unit' : ''}'
            : '--';

        final updatedAt = latest?.date != null
            ? DateTime.tryParse(latest!.date)
            : null;
        final updatedLabel = updatedAt != null
            ? S.of(context)!.bodyFatLastUpdated(
                DateFormat.yMMMEd(localeTag).format(updatedAt),
              )
            : null;

        String? companionText;
        if (metric == ffmiMetricKey) {
          final leanMassValue = leanMassAsync?.asData?.value?.value;
          companionText = leanMassValue != null
              ? '${S.of(context)!.leanMass}: ${_formatValue(leanMassValue)} kg'
              : '${S.of(context)!.leanMass}: --';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context)!.goalCurrentValue,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: textColor.withAlpha((255 * 0.7).toInt()),
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedValue,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (updatedLabel != null) ...[
              const SizedBox(height: 6),
              Text(
                updatedLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor.withAlpha((255 * 0.6).toInt()),
                    ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              S.of(context)!.autoTrackedMetricHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor.withAlpha((255 * 0.7).toInt()),
                  ),
            ),
            if (companionText != null) ...[
              const SizedBox(height: 12),
              Text(
                companionText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ],
        );
      },
      loading: () => const _AutoTrackedMetricShimmer(),
      error: (error, _) => Text(
        S.of(context)!.noData,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  ProgressGoal? _goalForMetric(List<ProgressGoal> goals, String metric) {
    for (final goal in goals) {
      if (goal.metric == metric && !goal.isCompleted) {
        return goal;
      }
    }
    return null;
  }

  Widget _buildMetricGoalSummary(BuildContext context, ProgressGoal goal) {
    final unit = getMetricUnit(goal.metric);
    final currentValue = goal.finalValue ?? goal.startValue;
    final directionDown = goal.targetValue < goal.startValue;
    final difference =
        (goal.targetValue - currentValue).abs().clamp(0.0, double.infinity);
    final accentColor = ThemeHelper.getFitPillColor(context);
    final l10n = S.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_rounded, color: accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n!.goalMetricSummaryTitle(getMetricName(context, goal.metric)),
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: goal.progressFraction,
            backgroundColor: accentColor.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            minHeight: 8,
          ),
          const SizedBox(height: 10),
          Text(
            directionDown
                ? l10n.goalMetricRemainingDown(
                    _formatValue(difference),
                    unit,
                  )
                : l10n.goalMetricRemainingUp(
                    _formatValue(difference),
                    unit,
                  ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            _deadlineLabel(context, goal),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }

  String _deadlineLabel(BuildContext context, ProgressGoal goal) {
    final l10n = S.of(context);
    if (goal.isCompleted) {
      final completedDate = goal.completedAt ?? DateTime.now();
      final locale = Localizations.localeOf(context).toLanguageTag();
      final formatted = DateFormat.yMMMd(locale).format(completedDate);
      return l10n!.goalCompletedOn(formatted);
    }

    final now = DateTime.now();
    final difference = goal.targetDate.difference(now).inDays;

    if (difference > 0) {
      return l10n!.goalDaysLeft(difference);
    } else if (difference == 0) {
      return l10n!.goalDueToday;
    } else {
      return l10n!.goalOverdue((-difference).abs());
    }
  }

  Future<void> _showGoalSheet(
    BuildContext context, {
    String? initialMetric,
    ProgressGoal? existingGoal,
  }) async {
    final notifier = ref.read(progressGoalsProvider.notifier);
    final result = await showModalBottomSheet<_GoalSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return _GoalFormSheet(
          initialMetric: initialMetric,
          existingGoal: existingGoal,
          readLatestValue: (metric) {
            final latestAsync = ref.read(latestMeasurementProvider(metric));
            return latestAsync.maybeWhen(
              data: (data) => data?.value,
              orElse: () => null,
            );
          },
          parseValue: _parseValue,
          formatValue: _formatValue,
          onCreate: (metric, startValue, targetValue, deadline) async {
            await notifier.addGoal(
              metric: metric,
              startValue: startValue,
              targetValue: targetValue,
              targetDate: deadline,
            );
          },
          onUpdate: (updatedGoal) async {
            await notifier.updateGoal(updatedGoal);
          },
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    final l10n = S.of(context);
    if (result == _GoalSheetResult.created) {
      SnackbarHelper.show(
        context,
        message: l10n!.goalFormSuccessCreated,
        backgroundColor: Colors.green,
      );
    } else if (result == _GoalSheetResult.updated) {
      SnackbarHelper.show(
        context,
        message: l10n!.goalFormSuccessUpdated,
        backgroundColor: Colors.green,
      );
    }
  }

  Future<void> _confirmDeleteGoal(
      BuildContext context, ProgressGoal goal) async {
    final l10n = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n!.goalDeleteDialogTitle),
          content: Text(l10n!.goalDeleteDialogMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.goalDeleteDialogConfirm),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await ref.read(progressGoalsProvider.notifier).deleteGoal(goal.id);
      if (mounted) {
        SnackbarHelper.show(
          context,
          message: l10n!.goalDeletedMessage,
          backgroundColor: Colors.redAccent,
        );
      }
    }
  }

  double? _parseValue(String input) {
    final sanitized = input.replaceAll(',', '.');
    return double.tryParse(sanitized);
  }

  String _formatValue(double value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }
}

class _MetricLatestValueBadge extends StatelessWidget {
  const _MetricLatestValueBadge({
    required this.metric,
    required this.latestMeasurementAsync,
  });

  final String metric;
  final AsyncValue<ProgressModel?> latestMeasurementAsync;

  @override
  Widget build(BuildContext context) {
    final Color accentColor = ThemeHelper.getFitPillColor(context);

    if (latestMeasurementAsync.isLoading) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
        ),
      );
    }

    if (latestMeasurementAsync.hasError) {
      return const Icon(
        Icons.error_outline,
        size: 18,
        color: Colors.redAccent,
      );
    }

    final double? latestValue = latestMeasurementAsync.value?.value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        latestValue != null ? formatMetricValue(metric, latestValue) : '--',
        style: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AutoTrackedMetricShimmer extends StatelessWidget {
  const _AutoTrackedMetricShimmer();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmer(height: 14, width: 120),
        SizedBox(height: 8),
        AppShimmer(height: 28, width: 90),
        SizedBox(height: 8),
        AppShimmer(height: 12, width: 160),
      ],
    );
  }
}

class _HighlightMetricConfig {
  const _HighlightMetricConfig({
    required this.metric,
    required this.labelBuilder,
    required this.unit,
    this.fractionDigits = 1,
  });

  final String metric;
  final String Function(BuildContext) labelBuilder;
  final String unit;
  final int fractionDigits;

  String format(double value) {
    final formatted = value.toStringAsFixed(fractionDigits);
    if (!formatted.contains('.')) {
      return formatted;
    }
    final trimmed = formatted
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
    return trimmed.isEmpty ? '0' : trimmed;
  }
}

class _HighlightMetricCard extends ConsumerWidget {
  const _HighlightMetricCard({
    required this.config,
    required this.goal,
  });

  final _HighlightMetricConfig config;
  final ProgressGoal? goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(graphDataProvider(config.metric));
    final isDarkTheme = ThemeHelper.isDarkTheme(context);
    final accentColor = isDarkTheme ? Colors.orange : const Color(0xFF0D47A1);

    Widget buildShell(Widget child) {
      return SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            color: ThemeHelper.getCardColor(context),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDarkTheme
                    ? Colors.black.withValues(alpha:0.4)
                    : Colors.black.withValues(alpha:0.12),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      );
    }

    return asyncData.when(
      loading: () => buildShell(
        Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
        ),
      ),
      error: (error, _) => buildShell(
        Center(
          child: Text(
            S.of(context)!.noData,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      data: (data) {
        if (data.isEmpty) {
          return buildShell(
            Center(
              child: Text(
                S.of(context)!.noData,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final latestValue = data.last.value;
        final targetValue = goal?.targetValue;        // istersen kalsın, target yine gösterilecek
        final startValue  = goal?.startValue;         // <--- EKLENDİ
        final difference  = startValue != null        // <--- DEĞİŞTİ: progress = current - start
            ? latestValue - startValue
            : null;


        return buildShell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.labelBuilder(context),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _HighlightValueTile(
                      label: S.of(context)!.goalCurrentValue,
                      value:
                          '${config.format(latestValue)} ${config.unit}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HighlightValueTile(
                      label: S.of(context)!.goalTargetValue,
                      value: targetValue != null
                          ? '${config.format(targetValue)} ${config.unit}'
                          : '--',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HighlightValueTile(
                      label: S.of(context)!.goalDifferenceValue,
                      value: difference == null
                          ? '--'
                          : difference == 0
                              ? '0 ${config.unit}'
                              : '${difference > 0 ? '+' : '-'}${config.format(difference.abs())} ${config.unit}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _HighlightMetricChart(
                  points: List<FlSpot>.generate(
                    data.length,
                    (index) => FlSpot(index.toDouble(), data[index].value),
                  ),
                  targetValue: targetValue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HighlightMetricChart extends StatelessWidget {
  const _HighlightMetricChart({
    required this.points,
    this.targetValue,
  });

  final List<FlSpot> points;
  final double? targetValue;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ThemeHelper.isDarkTheme(context);
    final accentColor = isDarkTheme ? Colors.orange : const Color(0xFF0D47A1);
    final targetColor =
        isDarkTheme ? Colors.tealAccent : Colors.deepOrangeAccent;

    if (points.isEmpty) {
      return Center(
        child: Text(
          S.of(context)!.noData,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    double minY = points.map((spot) => spot.y).reduce(math.min);
    double maxY = points.map((spot) => spot.y).reduce(math.max);

    if (targetValue != null) {
      minY = math.min(minY, targetValue!);
      maxY = math.max(maxY, targetValue!);
    }

    if ((maxY - minY).abs() < 1e-3) {
      maxY = minY + 1;
      minY = minY - 1;
    }

    final padding = (maxY - minY) * 0.1;
    final effectiveMinY = minY - padding;
    final effectiveMaxY = maxY + padding;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: points.first.x,
        maxX: points.last.x,
        minY: effectiveMinY,
        maxY: effectiveMaxY,
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: points,
            isCurved: points.length > 1,
            color: accentColor,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: accentColor.withValues(alpha:0.15),
            ),
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            if (targetValue != null)
              HorizontalLine(
                y: targetValue!,
                dashArray: const [6, 4],
                color: targetColor,
                strokeWidth: 2,
              ),
          ],
        ),
      ),
    );
  }
}

class _HighlightValueTile extends StatelessWidget {
  const _HighlightValueTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

enum _GoalSheetResult { created, updated }

class _GoalFormSheet extends StatefulWidget {
  const _GoalFormSheet({
    this.initialMetric,
    this.existingGoal,
    required this.readLatestValue,
    required this.parseValue,
    required this.formatValue,
    required this.onCreate,
    required this.onUpdate,
  });

  final String? initialMetric;
  final ProgressGoal? existingGoal;
  final double? Function(String metric) readLatestValue;
  final double? Function(String input) parseValue;
  final String Function(double value) formatValue;
  final Future<void> Function(
    String metric,
    double startValue,
    double targetValue,
    DateTime deadline,
  ) onCreate;
  final Future<void> Function(ProgressGoal goal) onUpdate;

  @override
  State<_GoalFormSheet> createState() => _GoalFormSheetState();
}

class _GoalFormSheetState extends State<_GoalFormSheet> {
  late String _selectedMetric;
  late DateTime _selectedDate;
  late TextEditingController _startController;
  late TextEditingController _targetController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedMetric =
        widget.existingGoal?.metric ?? widget.initialMetric ?? metrics.first;
    _selectedDate = widget.existingGoal?.targetDate ??
        DateTime.now().add(const Duration(days: 60));
    _startController = TextEditingController(
      text: widget.existingGoal != null
          ? widget.formatValue(widget.existingGoal!.startValue)
          : '',
    );
    _targetController = TextEditingController(
      text: widget.existingGoal != null
          ? widget.formatValue(widget.existingGoal!.targetValue)
          : '',
    );

    if (widget.existingGoal == null && _startController.text.isEmpty) {
      final latestValue = widget.readLatestValue(_selectedMetric);
      if (latestValue != null) {
        _startController.text = widget.formatValue(latestValue);
      }
    }
  }

  @override
  void dispose() {
    _startController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    final l10n = S.of(context);
    final startError =
        validateInput(_startController.text, _selectedMetric, context);
    final targetError =
        validateInput(_targetController.text, _selectedMetric, context);

    if (startError != null || targetError != null) {
      SnackbarHelper.show(
        context,
        message: startError ?? targetError ?? l10n!.error,
        backgroundColor: Colors.red,
      );
      return;
    }

    final startValue = widget.parseValue(_startController.text);
    final targetValue = widget.parseValue(_targetController.text);

    if (startValue == null || targetValue == null) {
      SnackbarHelper.show(
        context,
        message: l10n!.goalFormNumericError,
        backgroundColor: Colors.red,
      );
      return;
    }

    if (startValue == targetValue) {
      SnackbarHelper.show(
        context,
        message: l10n!.goalFormErrorEqualValues,
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (widget.existingGoal == null) {
        await widget.onCreate(
          _selectedMetric,
          startValue,
          targetValue,
          _selectedDate,
        );
        if (!mounted) {
          return;
        }
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop(_GoalSheetResult.created);
      } else {
        await widget.onUpdate(
          widget.existingGoal!.copyWith(
            metric: _selectedMetric,
            startValue: startValue,
            targetValue: targetValue,
            targetDate: _selectedDate,
          ),
        );
        if (!mounted) {
          return;
        }
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop(_GoalSheetResult.updated);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      SnackbarHelper.show(
        context,
        message: l10n!.error,
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final accentColor = ThemeHelper.isDarkTheme(context)
        ? Colors.orange
        : const Color(0xFF0D47A1);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Material(
        color: ThemeHelper.getCardColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: ThemeHelper.getTextColor(context)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Text(
                  widget.existingGoal == null
                      ? l10n!.goalFormTitle
                      : l10n!.goalFormUpdateTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedMetric,
                  decoration: InputDecoration(
                    labelText: l10n.goalFormMetricLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: metrics
                      .map(
                        (metric) => DropdownMenuItem(
                          value: metric,
                          child: Text(getMetricName(context, metric)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedMetric = value;
                      if (widget.existingGoal == null) {
                        final latest = widget.readLatestValue(value);
                        if (latest != null) {
                          _startController.text =
                              widget.formatValue(latest);
                        }
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _startController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.goalFormCurrentLabel,
                    suffixText: getMetricUnit(_selectedMetric),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _targetController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.goalFormTargetLabel,
                    suffixText: getMetricUnit(_selectedMetric),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.calendar_today, color: accentColor),
                  ),
                  title: Text(
                    l10n.goalFormDeadlineLabel,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd(
                      Localizations.localeOf(context).toLanguageTag(),
                    ).format(_selectedDate),
                  ),
                  trailing: TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 3),
                        ),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: Text(l10n.goalFormDeadlinePick),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).maybePop();
                        },
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: ThemeHelper.getBackgroundColor(context),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(l10n.goalFormSubmit),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
