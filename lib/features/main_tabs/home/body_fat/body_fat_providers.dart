import 'package:fitpill/features/main_tabs/progress/progress_model.dart';
import 'package:fitpill/features/main_tabs/progress/progress_repository.dart';
import 'package:fitpill/features/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final userId = ref.watch(userIdProvider);
  return ProgressRepository(userId: userId!);
});

final latestProgressMeasurementProvider =
    StreamProvider.family<ProgressModel?, String>((ref, metric) {
  final repository = ref.watch(_progressRepositoryProvider);
  return repository.watchLatestMeasurement(metric);
});
