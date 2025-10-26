import 'package:fitpill/features/main_tabs/home/do_with_me/do_with_me_activity_card.dart';

class ActivityTrackerParams {
  final Activity activity;
  final String tempoKey;
  final double incline;
  final int targetMinutes;

  const ActivityTrackerParams({
    required this.activity,
    required this.tempoKey,
    required this.incline,
    required this.targetMinutes,
  });
}
