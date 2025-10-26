// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod 3.x: AsyncNotifier<User?> kullanıyoruz.
/// - state: AsyncValue<User?>
/// - build(): ilk state'i üretir ve authStateChanges()'e abone olur.
///
///

@ProviderFor(AuthNotifier)
const authProvider = AuthNotifierProvider._();

/// Riverpod 3.x: AsyncNotifier<User?> kullanıyoruz.
/// - state: AsyncValue<User?>
/// - build(): ilk state'i üretir ve authStateChanges()'e abone olur.
///
///
final class AuthNotifierProvider
    extends $AsyncNotifierProvider<AuthNotifier, User?> {
  /// Riverpod 3.x: AsyncNotifier<User?> kullanıyoruz.
  /// - state: AsyncValue<User?>
  /// - build(): ilk state'i üretir ve authStateChanges()'e abone olur.
  ///
  ///
  const AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();
}

String _$authNotifierHash() => r'de882c1473c0f6ca881d6756d55945adca38c3dd';

/// Riverpod 3.x: AsyncNotifier<User?> kullanıyoruz.
/// - state: AsyncValue<User?>
/// - build(): ilk state'i üretir ve authStateChanges()'e abone olur.
///
///

abstract class _$AuthNotifier extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
