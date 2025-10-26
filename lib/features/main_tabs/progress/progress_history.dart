import 'dart:async';

import 'package:fitpill/core/utils/formatter.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/snackbar_helper.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'measurement_metrics.dart';
import 'progress_provider.dart';

class ProgressHistoryPage extends ConsumerWidget {
  final String metric;

  const ProgressHistoryPage({required this.metric, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressListAsync = ref.watch(progressHistoryProvider(metric));
    final bgclr = ThemeHelper.getBackgroundColor(context);
    ThemeHelper.getTextColor(context);
    final cardclr = ThemeHelper.getCardColor(context);
    ThemeHelper.isDarkTheme(context);
    final locale = Localizations.localeOf(context).toString();
    final isAutoTrackedMetric = autoTrackedMetrics.contains(metric);


    return Scaffold(
      backgroundColor: bgclr,
      appBar: AppBar(
        backgroundColor: bgclr,
        title: Text(
            '${getMetricName(context, metric)} ${S.of(context)!.history}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: ThemeHelper.getTextColor(context).withAlpha(30),
            ),
          ),
          Expanded(
            child: progressListAsync.when(
              loading: () => const AppPageShimmer(padding: EdgeInsets.all(16)),
              error: (e, st) => Center(child: Text(S.of(context)!.error)),
              data: (entries) {
                if (entries.isEmpty) {
                  return Center(child: Text(S.of(context)!.noData));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];

                    final date = DateTime.parse(entry.date);
                    final now = DateTime.now();
                    final difference = now.difference(date).inDays;

                    // final locale =
                    //     Localizations.localeOf(context) // çeviriye eklenmesi lazım
                    //         .toString(); // örn: 'tr_TR' ya da 'en_US'

                    // locale çeviiye eklendikten sonra byrayı aç:
                    //final timeAgoText = difference == 0
                    //     ? S.of(context).today
                    //     : difference == 1
                    //         ? S.of(context).one_day_ago // 1 day - 2 day(s)
                    //         : S.of(context).x_days_ago(difference);

                    final String timeAgoText = difference == 0
                        ? S.of(context)!.today
                        : '$difference ${S.of(context)!.dayAgo}';

                    Widget tile = ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ThemeHelper.isDarkTheme(context)
                                  ? Colors.orange
                                  : const Color(0xFF0D47A1),
                              width: 1.5),
                          color: bgclr,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          getMetricIcon(metric),
                          color: ThemeHelper.isDarkTheme(context)
                              ? Colors.orange
                              : const Color(0xFF0D47A1),
                          size: 24,
                        ),
                      ),
                      title: Text(
                        "${formatDoubleFromString(entry.value.toString())} ${getMetricUnit(metric)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ThemeHelper.getTextColor(context),
                        ),
                      ),
                      subtitle: Text(
                        '${DateFormat('dd MMMM yyyy', locale).format(date)} • $timeAgoText',
                        style: TextStyle(
                          color: ThemeHelper.getTextColor(context)
                              .withAlpha((255 * 0.7).toInt()),
                        ),
                      ),
                    );

                    if (!isAutoTrackedMetric) {
                      tile = Dismissible(
                        key: Key(entry.date),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) {
                          final completer = Completer<bool?>();

                          showCustomTextFieldDialog(
                              context: context,
                              title: 'Delete Routine',
                              labels: [],
                              height: 200,
                              icon: Icons.fitness_center,
                              confirmText: S.of(context)!.delete,
                              cancelText: S.of(context)!.cancel,
                              content: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  '$metric ${S.of(context)!.workoutWillBeDeleted}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              onCancel: () {
                                completer.complete(false);
                              },
                              onConfirm: (_) {
                                ref
                                    .read(progressProvider.notifier)
                                    .delete(metric, entry.date);
                                ref.invalidate(graphDataProvider);
                                ref.invalidate(allProgressDataProvider);
                                ref.invalidate(progressHistoryProvider(
                                    metric)); // Listeyi yeniden getir
                                SnackbarHelper.show(context,
                                    message: S.of(context)!.deleted,
                                    backgroundColor: Colors.green);
                                completer.complete(true);
                              });
                          return completer.future;
                        },
                        child: tile,
                      );
                    }

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      color: cardclr,
                      clipBehavior: Clip.hardEdge,
                      child: tile,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
