// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 🔹 ProfileImageRepository Provider (Statik Provider)
// Artık manuel Provider yerine Generator'ın ürettiği bir fonksiyon provider'ı kullanıyoruz.

@ProviderFor(profileImageRepository)
const profileImageRepositoryProvider = ProfileImageRepositoryProvider._();

/// 🔹 ProfileImageRepository Provider (Statik Provider)
// Artık manuel Provider yerine Generator'ın ürettiği bir fonksiyon provider'ı kullanıyoruz.

final class ProfileImageRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileImageRepository,
          ProfileImageRepository,
          ProfileImageRepository
        >
    with $Provider<ProfileImageRepository> {
  /// 🔹 ProfileImageRepository Provider (Statik Provider)
  // Artık manuel Provider yerine Generator'ın ürettiği bir fonksiyon provider'ı kullanıyoruz.
  const ProfileImageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileImageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileImageRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileImageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileImageRepository create(Ref ref) {
    return profileImageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileImageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileImageRepository>(value),
    );
  }
}

String _$profileImageRepositoryHash() =>
    r'23c6cc6142a6aebdeb40e8fd1189726d29ea5348';

/// 🔹 Premium Status Provider (Computed Provider)
// Bu, Generator ile oluşturulan AsyncNotifier'ın state'ini dinleyecektir.

@ProviderFor(premiumStatus)
const premiumStatusProvider = PremiumStatusProvider._();

/// 🔹 Premium Status Provider (Computed Provider)
// Bu, Generator ile oluşturulan AsyncNotifier'ın state'ini dinleyecektir.

final class PremiumStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<bool>,
          AsyncValue<bool>,
          AsyncValue<bool>
        >
    with $Provider<AsyncValue<bool>> {
  /// 🔹 Premium Status Provider (Computed Provider)
  // Bu, Generator ile oluşturulan AsyncNotifier'ın state'ini dinleyecektir.
  const PremiumStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'premiumStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$premiumStatusHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<bool>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<bool> create(Ref ref) {
    return premiumStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<bool>>(value),
    );
  }
}

String _$premiumStatusHash() => r'e450d0a372844f90af3c16e68349e57673eee666';

/// 🔹 Profile Notifier (AsyncNotifier - GENERATOR)
// AsyncNotifier, AsyncValue<UserProfileModel> türünü yönetmek için en uygunudur.
// _$Profile, Generator tarafından üretilen temel sınıftır.

@ProviderFor(Profile)
const profileProvider = ProfileProvider._();

/// 🔹 Profile Notifier (AsyncNotifier - GENERATOR)
// AsyncNotifier, AsyncValue<UserProfileModel> türünü yönetmek için en uygunudur.
// _$Profile, Generator tarafından üretilen temel sınıftır.
final class ProfileProvider
    extends $AsyncNotifierProvider<Profile, UserProfileModel> {
  /// 🔹 Profile Notifier (AsyncNotifier - GENERATOR)
  // AsyncNotifier, AsyncValue<UserProfileModel> türünü yönetmek için en uygunudur.
  // _$Profile, Generator tarafından üretilen temel sınıftır.
  const ProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileHash();

  @$internal
  @override
  Profile create() => Profile();
}

String _$profileHash() => r'75d3917b46cbdcfa6b12a54dd0bf058b14e75685';

/// 🔹 Profile Notifier (AsyncNotifier - GENERATOR)
// AsyncNotifier, AsyncValue<UserProfileModel> türünü yönetmek için en uygunudur.
// _$Profile, Generator tarafından üretilen temel sınıftır.

abstract class _$Profile extends $AsyncNotifier<UserProfileModel> {
  FutureOr<UserProfileModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<UserProfileModel>, UserProfileModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfileModel>, UserProfileModel>,
              AsyncValue<UserProfileModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
