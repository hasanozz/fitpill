import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/features/main_tabs/progress/measurement_metrics.dart';
import 'package:fitpill/features/main_tabs/progress/progress_goal_model.dart';
import 'package:fitpill/features/main_tabs/progress/progress_goals_provider.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../profile/profile_provider.dart';

class GoalSummaryCard extends ConsumerWidget {
  const GoalSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumStatus = ref.watch(premiumStatusProvider);
    final isPremium = premiumStatus.maybeWhen(
      data: (value) => value,
      orElse: () => false,
    );

    if (!isPremium) {
      return const SizedBox.shrink();
    }

    final goalsAsync = ref.watch(progressGoalsStreamProvider);

    return goalsAsync.when(
      data: (goals) {
        final activeGoals = goals
            .where((goal) => !goal.isCompleted)
            .toList()
          ..sort((a, b) => a.targetDate.compareTo(b.targetDate));

        final l10n = S.of(context);
        final accentColor = ThemeHelper.isDarkTheme(context)
            ? Colors.orange
            : const Color(0xFF0D47A1);
        final textColor = ThemeHelper.getTextColor(context);

        if (activeGoals.isEmpty) {
          return _GoalCardContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.flag_outlined, color: accentColor),
                    const SizedBox(width: 8),
                    Text(
                      l10n!.goalActiveSectionTitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.goalEmptyStateDescription,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textColor.withValues(alpha: 0.7)),
                ),
              ],
            ),
          );
        }

        final goal = activeGoals.first;
        final currentValue = goal.finalValue ?? goal.startValue;
        final directionDown = goal.targetValue < goal.startValue;
        final difference = (goal.targetValue - currentValue).abs();
        final unit = getMetricUnit(goal.metric);

        return _GoalCardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.flag_rounded, color: accentColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n!.goalMetricSummaryTitle(
                            getMetricName(context, goal.metric),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _deadlineLabel(context, goal),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: textColor.withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      directionDown
                          ? l10n.goalMetricRemainingDown(
                              _formatDifference(difference),
                              unit,
                            )
                          : l10n.goalMetricRemainingUp(
                              _formatDifference(difference),
                              unit,
                            ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: goal.progressFraction,
                backgroundColor: accentColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                minHeight: 6,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _GoalValueTile(
                      label: l10n.goalCurrentValue,
                      value: '${_formatDifference(currentValue)} $unit',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _GoalValueTile(
                      label: l10n.goalTargetValue,
                      value: '${_formatDifference(goal.targetValue)} $unit',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const _GoalCardLoading(),
      error: (error, _) => _GoalCardContainer(
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                S.of(context)!.goalErrorState,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: ThemeHelper.getTextColor(context)),
              ),
            ),
          ],
        ),
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

  String _formatDifference(double value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }
}

class _GoalCardContainer extends StatelessWidget {
  const _GoalCardContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 130),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _GoalValueTile extends StatelessWidget {
  const _GoalValueTile({required this.label, required this.value});

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
        const SizedBox(height: 4),
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

class _GoalCardLoading extends StatelessWidget {
  const _GoalCardLoading();

  @override
  Widget build(BuildContext context) {
    return _GoalCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppShimmer(height: 18, width: 160),
          SizedBox(height: 12),
          AppShimmer(height: 12, width: 220),
          SizedBox(height: 12),
          AppShimmer(height: 12, width: 180),
        ],
      ),
    );
  }
}
