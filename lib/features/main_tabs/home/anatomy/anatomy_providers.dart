// providers/anatomy_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'anatomy_repository.dart';
import 'anatomy_state.dart';

// Repo provider
final anatomyRepositoryProvider = Provider<AnatomyRepository>(
      (ref) => AnatomyRepository(),
);

// Notifier provider (autoDispose)
final anatomyProvider =
NotifierProvider.autoDispose<AnatomyNotifier, AnatomyState>(
  AnatomyNotifier.new,
);
