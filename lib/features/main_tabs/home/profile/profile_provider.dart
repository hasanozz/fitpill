// profile_provider.dart

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitpill/features/main_tabs/home/profile/user_profile_model.dart';
import 'package:fitpill/features/auth/auth_provider.dart';
import 'package:fitpill/features/profile/user/user_repository.dart';
// Yeni import: Generator için zorunlu
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitpill/features/profile/user/user_providers.dart';
import 'profile_image_repository.dart';
import 'package:fitpill/features/auth/auth_notifier.dart';
// Generator'ın üreteceği dosyayı işaret ediyoruz
part 'profile_provider.g.dart';




// ----------------------------------------------------------------------
// PROVIDER TANIMLARI (GENERATOR)
// ----------------------------------------------------------------------

/// 🔹 ProfileImageRepository Provider (Statik Provider)
// Artık manuel Provider yerine Generator'ın ürettiği bir fonksiyon provider'ı kullanıyoruz.
@Riverpod(keepAlive: true) // keepAlive, Auth durumu değişse bile Repository'nin ayakta kalmasını sağlar.
ProfileImageRepository profileImageRepository(Ref ref) {
  return ProfileImageRepository(storage: FirebaseStorage.instance);
}


/// 🔹 Premium Status Provider (Computed Provider)
// Bu, Generator ile oluşturulan AsyncNotifier'ın state'ini dinleyecektir.
@Riverpod(keepAlive: true)
AsyncValue<bool> premiumStatus(Ref ref) {
  // profileProvider (Generator tarafından üretilen isim) izlenir.
  final profileState = ref.watch(profileProvider);
  return profileState.whenData((profile) => profile.hasActivePremium);
}


// ----------------------------------------------------------------------
// NOTIFIER SINIFI (AsyncNotifier)
// ----------------------------------------------------------------------

/// 🔹 Profile Notifier (AsyncNotifier - GENERATOR)
// AsyncNotifier, AsyncValue<UserProfileModel> türünü yönetmek için en uygunudur.
// _$Profile, Generator tarafından üretilen temel sınıftır.
@Riverpod(keepAlive: true) // Oturum açıp kapanmalarda state'in korunması için.
class Profile extends _$Profile {

  // Sınıf alanlarını build içinde çözebiliriz.


  @override
  Future<UserProfileModel> build() async {
    // 1. Bağımlılıkları çözme
    // Generator, userRepositoryProvider'ı ürettiği için direkt kullanırız.

    // 2. Auth durumu değişimini izleme
    // ref.listen() manuel kullanımına gerek kalmadı!
    // ref.watch(authProvider) ile bir değişiklik olduğunda build() metodu yeniden çalışır.
    final uid = ref.watch(userIdProvider);

    if (uid == null) {
      // Kullanıcı çıkış yaptıysa veya oturum açmadıysa
      // AsyncNotifier'ın başlangıç state'i olan AsyncLoading'i döndürmez.
      // throw (veya `return Future.error`) AsyncError'a neden olur.
      // Bu, UI'da Loading yerine 'Not Authenticated' gibi bir hata göstermemizi sağlar.
      // NOTE: Orijinal kodda AsyncValue.loading() döndürüldüğünden, burada da buna yakın bir davranış sergilenmeli.
      // Generator kullanırken, oturum yoksa biz de yükleme yapmayız.
      // İlk yükleme başarılıysa ve sonra çıkış yapıldıysa state `AsyncError` olur.

      // Kullanıcının oturum açmasını beklemek için boş bir Future döndürebiliriz
      // ya da bir hata fırlatıp UI'ın boş kalmasını sağlayabiliriz.
      return Future.error('User not authenticated, profile not loaded.', StackTrace.current);
    }
    final userRepository = ref.watch(userRepositoryProvider);

    // 3. Veriyi yükleme
    return _loadProfile(uid, userRepository);
  }

  /// -------------------------------------------
  /// MANTIK METOTLARI
  /// -------------------------------------------

  Future<UserProfileModel> _loadProfile(String userId, UserRepository repository) async {
    // Notifier'da state = AsyncValue.loading() yapmaya gerek yoktur.
    // build() metodu yeniden çalıştığında bu zaten AsyncLoading state'ine geçer.
    // Ancak dışarıdan çağrılan fetchProfile metodu için manuel loading atılabilir.

    final profileData = await repository.getUserProfile(userId);
    if (profileData != null) {
      return UserProfileModel.fromMap(profileData, id: userId);
    } else {
      throw Exception('Profil bulunamadı');
    }
  }

  /// Orijinaldeki gibi, dışarıdan manuel çağırmak için.
  Future<void> fetchProfile() async {
    final uid = ref.read(userIdProvider);
    if (uid == null) {
      state = AsyncValue.error('User is not authenticated', StackTrace.current);
      return;
    }
    // _loadProfile'ı doğrudan çağırıp state'i güncellemek yerine
    // AsyncNotifier'ın state'ini yeniden hesaplamasını isteriz.
    final userRepository = ref.read(userRepositoryProvider);
    state = await AsyncValue.guard(() => _loadProfile(uid, userRepository));
  }

  Future<void> updateProfile(UserProfileModel updatedProfile) async {
    final uid = ref.read(userIdProvider);
    if (uid == null) throw Exception('User is not authenticated');
    final userRepository = ref.read(userRepositoryProvider);
    // AsyncNotifier'da state'i manuel olarak güncellemek için update metodu kullanılır.
    await update((currentProfile) async {
      await userRepository.updateUserProfile(uid, updatedProfile.toMap());
      return updatedProfile; // Yeni state'i döndür
    });
  }

  Future<void> uploadProfileImage(File imageFile) async {
    final uid = ref.read(userIdProvider);
    if (uid == null) throw Exception('User is not authenticated');

    final currentProfile = state.value;
    if (currentProfile == null) throw Exception('Profile is not loaded');

    final repository = ref.read(profileImageRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);

    await update((currentProfile) async {
      final previousPath =
      repository.resolveStoragePath(currentProfile.profileImage);

      final downloadUrl = await repository.uploadProfileImage(
        userId: uid,
        file: imageFile,
        previousUrl: currentProfile.profileImage,
      );
      final newPath = repository.resolveStoragePath(downloadUrl);

      final updatedProfile = currentProfile.copyWith(
        profileImage: downloadUrl,
        avatar: null,
      );

      await userRepository.updateUserProfile(
        uid,
        updatedProfile.toMap(),
      );

      // Eski görseli silme mantığı
      if (previousPath != null && previousPath != newPath) {
        await repository.deleteProfileImage(currentProfile.profileImage);
      }

      return updatedProfile;
    });
  }

  Future<void> removeProfileImage() async {
    final uid = ref.read(userIdProvider);
    if (uid == null) throw Exception('User is not authenticated');

    final userRepository = ref.read(userRepositoryProvider);

    await update((currentProfile) async {
      final repository = ref.read(profileImageRepositoryProvider);
      await repository.deleteProfileImage(currentProfile.profileImage);

      final updatedProfile = currentProfile.copyWith(
        profileImage: null,
      );

      await userRepository.updateUserProfile(
        uid,
        updatedProfile.toMap(),
      );
      return updatedProfile;
    });
  }

  Future<void> selectAvatar(String avatarName) async {
    final uid = ref.read(userIdProvider);
    if (uid == null) throw Exception('User is not authenticated');

    final userRepository = ref.read(userRepositoryProvider);

    await update((currentProfile) async {
      final repository = ref.read(profileImageRepositoryProvider);
      // Profil resmi varsa sil
      if (currentProfile.profileImage != null) {
        await repository.deleteProfileImage(currentProfile.profileImage);
      }

      final updatedProfile = currentProfile.copyWith(
        avatar: avatarName,
        profileImage: null,
      );

      await userRepository.updateUserProfile(
        uid,
        updatedProfile.toMap(),
      );
      return updatedProfile;
    });
  }
}