import 'badge_data.dart';
import 'badge_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpill/features/auth/auth_provider.dart';

// ÖNEMLİ: Bu provider'ın doğru çalışması için BadgeRepository, BadgeData ve userIdProvider
// sınıflarınızın ve importlarınızın mevcut olduğunu varsayıyorum.

// ----- Badge Repository Provider (Bağımlılığı yönetmek için) -----
// Bu, Repository'yi userId değiştiğinde otomatik olarak yeniden oluşturur.
final badgeRepositoryProvider = Provider<BadgeRepository>((ref) {
  final userId = ref.watch(userIdProvider);
  // Kullanıcı ID'si null ise, Repository'nizin ne yapması gerektiğine karar verin.
  // Varsayım: Repository, null ID'yi ele alacak veya bir varsayılan ID kullanılacak.
  return BadgeRepository(userId: userId ?? 'default_user_id');
});


// ----- Badge Notifier (AsyncNotifier) -----
class BadgeAsyncNotifier extends AsyncNotifier<BadgeData> {
  // Notifier'ın ilk durumu oluşturulur ve veri yüklenir.
  @override
  Future<BadgeData> build() async {
    // Repository'yi buradan izliyoruz. userId değişirse, build metodu yeniden çalışır.
    final repository = ref.watch(badgeRepositoryProvider);
    return repository.getBadgeData();
  }

  // refresh fonksiyonu, build metodunu yeniden çalıştırmak için basitleştirildi.
  Future<void> refresh() async {
    // state = const AsyncLoading(); ve manuel try-catch'e gerek yok.
    // ref.invalidateSelf(), build'i yeniden çalıştırır ve state'i günceller.
    ref.invalidateSelf();
    await future; // Yenileme işleminin bitmesini bekler.
  }
}

// ----- Badge Provider (AsyncNotifierProvider) -----
final badgeProvider =
AsyncNotifierProvider<BadgeAsyncNotifier, BadgeData>(
  BadgeAsyncNotifier.new,
);