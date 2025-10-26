import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/features/main_tabs/home/do_with_me/activity_provider.dart';
import 'package:fitpill/features/main_tabs/home/do_with_me/activity_tracker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fitpill/l10n/l10n_extensions.dart';
import 'do_with_me_activity_card.dart';

class ActivityTrackerScreen extends ConsumerStatefulWidget {
  final Activity activity;
  final String tempoKey;
  final double incline;
  final int targetMinutes;

  const ActivityTrackerScreen({
    super.key,
    required this.activity,
    required this.tempoKey,
    required this.incline,
    required this.targetMinutes,
  });

  @override
  ConsumerState<ActivityTrackerScreen> createState() =>
      _ActivityTrackerScreenState();
}

class _ActivityTrackerScreenState extends ConsumerState<ActivityTrackerScreen> {
  late final ActivityTrackerParams _params;
  bool _workoutFinished =
      false; // workout popup kontrolü -> antrenman içinde geri tuşuna basılırsa diye

  @override
  void initState() {
    super.initState();
    _params = ActivityTrackerParams(
      activity: widget.activity,
      tempoKey: widget.tempoKey,
      incline: widget.incline,
      targetMinutes: widget.targetMinutes,
    );

    // ekran ilk açıldığında start() çağırıyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activityTrackerProvider(_params).notifier).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final trackerState = ref.watch(activityTrackerProvider(_params));
    final trackerNotifier = ref.read(activityTrackerProvider(_params).notifier);

    return WillPopScope(
      onWillPop: () async {
        if (!_workoutFinished && trackerState.isRunning) {
          final shouldExit = await _showExitConfirmDialog(context);
          if (shouldExit == true) Navigator.pop(context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context)!.getTranslation(widget.activity.name)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SfRadialGauge(
                axes: [
                  RadialAxis(
                    minimum: 0,
                    maximum: widget.targetMinutes * 60.toDouble(),
                    ranges: [
                      GaugeRange(
                        startValue: 0,
                        endValue:
                            trackerState.totalElapsed.inSeconds.toDouble(),
                        color: Colors.blue,
                      )
                    ],
                    pointers: [
                      NeedlePointer(
                        value: trackerState.totalElapsed.inSeconds.toDouble(),
                        needleLength: 0.7,
                      )
                    ],
                    annotations: [
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${trackerState.totalElapsed.inMinutes.toString().padLeft(2, '0')}:${(trackerState.totalElapsed.inSeconds % 60).toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${trackerState.caloriesBurned.round()} kcal',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'pause_resume',
                    backgroundColor:
                        trackerState.isPaused ? Colors.green : Colors.amber,
                    onPressed: () {
                      if (trackerState.isPaused) {
                        trackerNotifier.resume();
                      } else {
                        trackerNotifier.pause();
                      }
                    },
                    child: Icon(
                      trackerState.isPaused ? Icons.play_arrow : Icons.pause,
                    ),
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'stop',
                    backgroundColor: Colors.red,
                    icon: const Icon(Icons.stop),
                    label: const Text(
                      'Bitir',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final confirmed = await _showConfirmDialog(context);
                      if (confirmed) {
                        final savedToHistory =
                            await trackerNotifier.stop();
                        ref.invalidate(activityProvider);
                        setState(() => _workoutFinished = true);
                        final finalState =
                            ref.read(activityTrackerProvider(_params));
                        await _showCompletionDialog(
                          context,
                          finalState,
                          savedToHistory,
                        );
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade100,
                    Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withAlpha((255 * 0.2).toInt()),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      size: 80, color: Colors.green),

                  const SizedBox(height: 15),

                  Text(
                    'Antrenmanı Bitir?',
                    // Sabit Türkçe yazıyorum çünkü S.of yok senin ilk gönderdiğinde
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue.shade800,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 25),

                  // Butonlar
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            side: BorderSide(color: Colors.blue.shade300),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back_rounded,
                                  color: Colors.blue.shade600, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'İptal',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.stop_rounded,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Bitir',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }

  Future<bool> _showExitConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Center(
              child:
                  Icon(Icons.warning_rounded, size: 48, color: Colors.orange),
            ),
            content: const Text(
              'Çıkmak istiyor musun? Antrenman kaydedilmeyecek.',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Çık'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _showCompletionDialog(
      BuildContext context,
      ActivityTrackerState trackerState,
      bool savedToHistory) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(); // Home'a yönlendir
          return true;
        },
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Center(
            child: Wrap(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 32),
                const SizedBox(width: 10),
                Text(
                  S.of(context)!.workoutCompleted,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildStatCard(
                  Icons.timer,
                  S.of(context)!.duration,
                  '${trackerState.totalElapsed.inMinutes} ${S.of(context)!.minutes}',
                  Colors.blue,
                ),
                _buildStatCard(
                  Icons.local_fire_department,
                  S.of(context)!.calories,
                  '${trackerState.caloriesBurned.round()} kcal',
                  Colors.orange,
                ),
                if (widget.activity.name == 'walk' ||
                    widget.activity.name == 'run')
                  _buildStatCard(
                    Icons.terrain,
                    S.of(context)!.incline,
                    '${widget.incline.toStringAsFixed(1)}%',
                    Colors.green,
                  ),
                _buildStatCard(
                  Icons.speed,
                  S.of(context)!.tempo,
                  S.of(context)!.getTempoName(widget.tempoKey),
                  Colors.purple,
                ),
                if (!savedToHistory)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      S.of(context)!.workoutHistoryNotSaved,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(
                  S.of(context)!.ok,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon, String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    )),
                Text(value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
