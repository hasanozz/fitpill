// providers/backpack_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpill/features/auth/auth_notifier.dart';

import 'backpack_bag.dart';
import 'backpack_item.dart';
import 'backpack_repository.dart';

/// ------------------------------------------------------------
/// REPOSITORY (user yoksa null döndürür)
/// ------------------------------------------------------------
final backpackRepositoryProvider = Provider<BackpackRepository?>((ref) {
  final user = ref.watch(authProvider).asData?.value; // AsyncValue<User?>
  if (user == null) return null;
  return BackpackRepository(userId: user.uid);
});

/// ------------------------------------------------------------
/// BAGS: Listeyi tutan ve yöneten AsyncNotifier
/// ------------------------------------------------------------
class BackpackBagNotifier extends AsyncNotifier<List<BackpackBag>> {
  BackpackRepository? get _repo => ref.watch(backpackRepositoryProvider);

  @override
  Future<List<BackpackBag>> build() async {
    if (_repo == null) return <BackpackBag>[];

    final bags = await _repo!.loadBags();

    if (bags.isEmpty) {
      final def = await _repo!.createDefaultBag();
      return [def];
    }
    if (!bags.any((b) => b.isDefault)) {
      final def = await _repo!.createDefaultBag();
      return [def, ...bags];
    }
    return bags;
  }

  Future<void> reload() async {
    if (_repo == null) {
      state = const AsyncData(<BackpackBag>[]);
      return;
    }
    final previous = state;
    state = const AsyncLoading();
    try {
      final bags = await _repo!.loadBags();
      if (bags.isEmpty) {
        final def = await _repo!.createDefaultBag();
        state = AsyncData([def]);
        return;
      }
      if (!bags.any((b) => b.isDefault)) {
        final def = await _repo!.createDefaultBag();
        state = AsyncData([def, ...bags]);
        return;
      }
      state = AsyncData(bags);
    } catch (e, st) {
      state = AsyncError<List<BackpackBag>>(e, st).copyWithPrevious(previous);
    }
  }

  Future<void> addBag(String name) async {
    if (_repo == null) return;
    final previous = state;
    final current = state.asData?.value ?? <BackpackBag>[];
    try {
      final newBag = await _repo!.addBag(name);
      state = AsyncData([...current, newBag]);
    } catch (e, st) {
      state = AsyncError<List<BackpackBag>>(e, st).copyWithPrevious(previous);
    }
  }

  Future<void> deleteBag(String id) async {
    if (_repo == null) return;
    final previous = state;
    final current = state.asData?.value ?? <BackpackBag>[];
    // optimistic
    state = AsyncData(current.where((b) => b.id != id).toList());
    try {
      await _repo!.deleteBag(id);
    } catch (e, st) {
      state = AsyncError<List<BackpackBag>>(e, st).copyWithPrevious(previous);
    }
  }

  Future<void> renameBag(String id, String newName) async {
    if (_repo == null) return;
    final previous = state;
    final current = state.asData?.value ?? <BackpackBag>[];
    // optimistic
    state = AsyncData([
      for (final b in current) if (b.id == id) b.copyWith(name: newName) else b
    ]);
    try {
      await _repo!.updateBagName(id, newName);
    } catch (e, st) {
      state = AsyncError<List<BackpackBag>>(e, st).copyWithPrevious(previous);
    }
  }
}

final backpackBagProvider =
AsyncNotifierProvider<BackpackBagNotifier, List<BackpackBag>>(
  BackpackBagNotifier.new,
);

/// ------------------------------------------------------------
/// ITEMS: Okuma için FutureProvider.family
/// ------------------------------------------------------------
/// UI'da: final items = ref.watch(backpackItemsProvider(bagId))
final backpackItemsProvider =
FutureProvider.family<List<BackpackItem>, String>((ref, bagId) async {
  final repo = ref.watch(backpackRepositoryProvider);
  if (repo == null) return <BackpackItem>[];
  return repo.fetchItems(bagId);
});

/// ------------------------------------------------------------
/// ITEMS COMMANDS: Yazma işlemleri için Notifier (stateless komut katmanı)
/// - İşlem sonrası listeyi invalidates ederiz: ref.invalidate(backpackItemsProvider(bagId))
/// - İstersen optimistic UI'ı Widget tarafında, lokal state ile yaparsın.
/// ------------------------------------------------------------
class BackpackItemsCommands extends Notifier<void> {
  BackpackRepository? get _repo => ref.read(backpackRepositoryProvider);

  @override
  void build() {
    // Komut katmanında global state tutmuyoruz.
  }

  Future<void> addItem(String bagId, BackpackItem item) async {
    if (_repo == null) return;
    // indeksi repo zaten hesaplıyor (addItemToBag içinde)
    await _repo!.addItemToBag(bagId, item);
    // listeyi tazele
    ref.invalidate(backpackItemsProvider(bagId));
  }

  Future<void> deleteItem(String bagId, String itemName) async {
    if (_repo == null) return;
    await _repo!.deleteItemFromBag(bagId, itemName);
    // listeyi tazele
    ref.invalidate(backpackItemsProvider(bagId));
  }
}

final backpackItemsCommandsProvider =
NotifierProvider<BackpackItemsCommands, void>(
  BackpackItemsCommands.new,
);
