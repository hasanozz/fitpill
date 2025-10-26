import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'setup_model.dart';
import 'setup_repository.dart';

// NOT: Projende zaten varsa bu provider satırını tekrarlama.
// final setupRepositoryProvider = Provider<SetupRepository>((ref) => SetupRepository());

class SetupNotifier extends Notifier<SetupData> {
  late final SetupRepository _repo = ref.read(setupRepositoryProvider);

  @override
  SetupData build() => const SetupData(); // başlangıç form state'i

  void updateBirthDate(DateTime birthDate) =>
      state = state.copyWith(birthDate: birthDate); // alan güncelle

  void updateGender(String gender) =>
      state = state.copyWith(gender: gender);

  void updateHeight(String height) =>
      state = state.copyWith(height: height);

  void updateWeight(String weight) =>
      state = state.copyWith(weight: weight);

  Future<void> saveSetupData() async =>
      _repo.saveSetupData(state); // mevcut form state'ini kaydet
}

// Eski: StateNotifierProvider → Yeni: NotifierProvider
final setupProvider = NotifierProvider<SetupNotifier, SetupData>(SetupNotifier.new);