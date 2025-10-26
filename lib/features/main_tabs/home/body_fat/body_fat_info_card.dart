import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'body_fat_providers.dart';
import 'package:fitpill/features/main_tabs/progress/measurement_metrics.dart';
import 'package:fitpill/features/main_tabs/progress/progress_model.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:fitpill/features/auth/auth_provider.dart';
import 'package:fitpill/features/profile/user/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'body_fat_utils.dart';

class BodyFatInfoCard extends ConsumerWidget {
  const BodyFatInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    final userAsync = ref.watch(userProfileProvider(userId!));
    final waistAsync = ref.watch(latestProgressMeasurementProvider('waist'));
    final neckAsync = ref.watch(latestProgressMeasurementProvider('neck'));
    final hipAsync = ref.watch(latestProgressMeasurementProvider('hip'));
    final weightAsync =
        ref.watch(latestProgressMeasurementProvider('weight'));
    final leanMassAsync =
        ref.watch(latestProgressMeasurementProvider(leanMassMetricKey));
    final ffmiAsync =
        ref.watch(latestProgressMeasurementProvider(ffmiMetricKey));

    final isDarkTheme = ThemeHelper.isDarkTheme(context);

    return userAsync.when(
      loading: () => _BodyFatCardContainer(
        isDarkTheme: isDarkTheme,
        child: const _BodyFatCardShimmer(),
      ),
      error: (error, _) => _BodyFatCardContainer(
        isDarkTheme: isDarkTheme,
        child: _InfoMessage(
          icon: Icons.error_outline,
          message: S.of(context)!.fatRateInfo,
        ),
      ),
      data: (profileData) {
        final gender = (profileData?['gender'] as String?)?.toLowerCase();
        final heightRaw = profileData?['height'];
        final height = switch (heightRaw) {
          num value => value.toDouble(),
          String value => double.tryParse(value),
          _ => null,
        };

        if (gender == null || gender.isEmpty || height == null || height <= 0) {
          return _BodyFatCardContainer(
            isDarkTheme: isDarkTheme,
            child: _InfoMessage(
              icon: Icons.info_outline,
              message: S.of(context)!.bodyFatMissingProfileInfo,
            ),
          );
        }

        final requiredMetrics = <String, AsyncValue<ProgressModel?>>{
          'waist': waistAsync,
          'neck': neckAsync,
          if (gender == 'female') 'hip': hipAsync,
        };

        final hasLoadingMetric = requiredMetrics.values.any((value) => value.isLoading);
        if (hasLoadingMetric) {
          return _BodyFatCardContainer(
            isDarkTheme: isDarkTheme,
            child: const _BodyFatCardShimmer(),
          );
        }

        final errorMetric = requiredMetrics.values.firstWhere(
          (value) => value.hasError,
          orElse: () => const AsyncData<ProgressModel?>(null),
        );

        if (errorMetric.hasError) {
          return _BodyFatCardContainer(
            isDarkTheme: isDarkTheme,
            child: _InfoMessage(
              icon: Icons.error_outline,
              message: S.of(context)!.fatRateInfo,
            ),
          );
        }

        final measurements = <String, ProgressModel>{};
        final missingMetrics = <String>[];

        requiredMetrics.forEach((metric, asyncValue) {
          final model = asyncValue.asData?.value;
          if (model == null) {
            missingMetrics.add(metric);
          } else {
            measurements[metric] = model;
          }
        });

        if (missingMetrics.isNotEmpty) {
          final metricsText = missingMetrics
              .map((metric) => getMetricName(context, metric))
              .join(', ');
          return _BodyFatCardContainer(
            isDarkTheme: isDarkTheme,
            child: _InfoMessage(
              icon: Icons.straighten,
              message: S.of(context)!.bodyFatMissingMeasurements(metricsText),
            ),
          );
        }

        final waist = measurements['waist']!.value;
        final neck = measurements['neck']!.value;
        final hip = gender == 'female' ? measurements['hip']!.value : null;

        final canCalculate = gender == 'male'
            ? waist > neck
            : hip != null && waist + hip > neck;

        if (!canCalculate) {
          return _BodyFatCardContainer(
            isDarkTheme: isDarkTheme,
            child: _InfoMessage(
              icon: Icons.warning_amber_outlined,
              message: S.of(context)!.bodyFatInvalidMeasurements,
            ),
          );
        }

        final fatPercentage = BodyFatUtils.calculateBodyFatPercentage(
          gender: gender,
          waist: waist,
          neck: neck,
          hip: hip,
          height: height,
        );

        if (fatPercentage == null || fatPercentage.isNaN) {
          return _BodyFatCardContainer(
            isDarkTheme: isDarkTheme,
            child: _InfoMessage(
              icon: Icons.warning_amber_outlined,
              message: S.of(context)!.bodyFatInvalidMeasurements,
            ),
          );
        }

        final normalizedFat = BodyFatUtils.normalizeBodyFat(fatPercentage);

        final weightMeasurement = weightAsync.asData?.value;
        final storedLeanMass = leanMassAsync.asData?.value?.value;
        final storedFfmi = ffmiAsync.asData?.value?.value;

        final leanMass = storedLeanMass ?? (weightMeasurement != null
            ? BodyFatUtils.calculateLeanMass(
                weight: weightMeasurement.value,
                bodyFatPercentage: normalizedFat,
              )
            : null);

        final ffmi = storedFfmi ?? (leanMass != null
            ? BodyFatUtils.calculateFfmi(
                leanMassKg: leanMass,
                heightCm: height,
              )
            : null);

        final lastUpdated = measurements.values
            .map((model) => DateTime.tryParse(model.date))
            .whereType<DateTime>()
            .fold<DateTime?>(null, (previous, current) {
          if (previous == null) return current;
          return current.isAfter(previous) ? current : previous;
        });

        final locale = Localizations.localeOf(context).toString();
        final formattedDate = lastUpdated != null
            ? DateFormat.yMMMEd(locale).format(lastUpdated)
            : null;

        return _BodyFatCardContainer(
          isDarkTheme: isDarkTheme,
          child: Row(
            children: [
              Expanded(
                child: _MetricHighlight(
                  title: S.of(context)!.bodyFatPercentage,
                  value: '${normalizedFat.toStringAsFixed(1)}%',
                  subtitle: formattedDate != null
                      ? S.of(context)!.bodyFatLastUpdated(formattedDate)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MetricHighlight(
                  title: S.of(context)!.ffmi,
                  value: ffmi != null && ffmi.isFinite
                      ? ffmi.toStringAsFixed(1)
                      : '--',
                  subtitle: leanMass != null && leanMass.isFinite
                      ? '${S.of(context)!.leanMass}: ${leanMass.toStringAsFixed(1)} kg \n'
                      : '${S.of(context)!.leanMass}: -- \n',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

class _BodyFatCardContainer extends StatelessWidget {
  const _BodyFatCardContainer({
    required this.child,
    required this.isDarkTheme,
  });

  final Widget child;
  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkTheme
                ? const [Color(0xFF1F1F1F), Color(0xFF2A2A2A)]
                : const [Color(0xFF14213D), Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _BodyFatCardShimmer extends StatelessWidget {
  const _BodyFatCardShimmer();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppShimmer(height: 18, width: 140),
              SizedBox(height: 12),
              AppShimmer(height: 36, width: 90),
              SizedBox(height: 12),
              AppShimmer(height: 14, width: 120),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppShimmer(height: 18, width: 100),
              SizedBox(height: 12),
              AppShimmer(height: 36, width: 90),
              SizedBox(height: 12),
              AppShimmer(height: 14, width: 140),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoMessage extends StatelessWidget {
  const _InfoMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}

class _MetricHighlight extends StatelessWidget {
  const _MetricHighlight({
    required this.title,
    required this.value,
    this.subtitle,
  });

  final String title;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha:0.8),
                ),
          ),
        ],
      ],
    );
  }
}
