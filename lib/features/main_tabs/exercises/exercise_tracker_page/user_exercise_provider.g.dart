// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_exercise_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ---------------------------------------------------------------------------
/// USER-EXERCISE STATE (ASYNC) — Riverpod 3.x tarzı
/// ---------------------------------------------------------------------------
/// Eskiden: StateNotifier<AsyncValue<List<ExerciseSet>>> + StateNotifierProvider.family
/// Şimdi:   AsyncNotifier<List<ExerciseSet>> + AsyncNotifierProvider.family
///
/// Family argümanını `build(String exerciseId)` ile alıyoruz.
/// Bu sınıf, tek bir egzersizin (exerciseId) set listesini yönetir.
///

@ProviderFor(UserExercise)
const userExerciseProvider = UserExerciseFamily._();

/// ---------------------------------------------------------------------------
/// USER-EXERCISE STATE (ASYNC) — Riverpod 3.x tarzı
/// ---------------------------------------------------------------------------
/// Eskiden: StateNotifier<AsyncValue<List<ExerciseSet>>> + StateNotifierProvider.family
/// Şimdi:   AsyncNotifier<List<ExerciseSet>> + AsyncNotifierProvider.family
///
/// Family argümanını `build(String exerciseId)` ile alıyoruz.
/// Bu sınıf, tek bir egzersizin (exerciseId) set listesini yönetir.
///
final class UserExerciseProvider
    extends $AsyncNotifierProvider<UserExercise, List<ExerciseSet>> {
  /// ---------------------------------------------------------------------------
  /// USER-EXERCISE STATE (ASYNC) — Riverpod 3.x tarzı
  /// ---------------------------------------------------------------------------
  /// Eskiden: StateNotifier<AsyncValue<List<ExerciseSet>>> + StateNotifierProvider.family
  /// Şimdi:   AsyncNotifier<List<ExerciseSet>> + AsyncNotifierProvider.family
  ///
  /// Family argümanını `build(String exerciseId)` ile alıyoruz.
  /// Bu sınıf, tek bir egzersizin (exerciseId) set listesini yönetir.
  ///
  const UserExerciseProvider._({
    required UserExerciseFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userExerciseProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userExerciseHash();

  @override
  String toString() {
    return r'userExerciseProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserExercise create() => UserExercise();

  @override
  bool operator ==(Object other) {
    return other is UserExerciseProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userExerciseHash() => r'c6d0d012aaff24d5e9763f5745fe4b4148c25158';

/// ---------------------------------------------------------------------------
/// USER-EXERCISE STATE (ASYNC) — Riverpod 3.x tarzı
/// ---------------------------------------------------------------------------
/// Eskiden: StateNotifier<AsyncValue<List<ExerciseSet>>> + StateNotifierProvider.family
/// Şimdi:   AsyncNotifier<List<ExerciseSet>> + AsyncNotifierProvider.family
///
/// Family argümanını `build(String exerciseId)` ile alıyoruz.
/// Bu sınıf, tek bir egzersizin (exerciseId) set listesini yönetir.
///

final class UserExerciseFamily extends $Family
    with
        $ClassFamilyOverride<
          UserExercise,
          AsyncValue<List<ExerciseSet>>,
          List<ExerciseSet>,
          FutureOr<List<ExerciseSet>>,
          String
        > {
  const UserExerciseFamily._()
    : super(
        retry: null,
        name: r'userExerciseProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ---------------------------------------------------------------------------
  /// USER-EXERCISE STATE (ASYNC) — Riverpod 3.x tarzı
  /// ---------------------------------------------------------------------------
  /// Eskiden: StateNotifier<AsyncValue<List<ExerciseSet>>> + StateNotifierProvider.family
  /// Şimdi:   AsyncNotifier<List<ExerciseSet>> + AsyncNotifierProvider.family
  ///
  /// Family argümanını `build(String exerciseId)` ile alıyoruz.
  /// Bu sınıf, tek bir egzersizin (exerciseId) set listesini yönetir.
  ///

  UserExerciseProvider call(String exerciseId) =>
      UserExerciseProvider._(argument: exerciseId, from: this);

  @override
  String toString() => r'userExerciseProvider';
}

/// ---------------------------------------------------------------------------
/// USER-EXERCISE STATE (ASYNC) — Riverpod 3.x tarzı
/// ---------------------------------------------------------------------------
/// Eskiden: StateNotifier<AsyncValue<List<ExerciseSet>>> + StateNotifierProvider.family
/// Şimdi:   AsyncNotifier<List<ExerciseSet>> + AsyncNotifierProvider.family
///
/// Family argümanını `build(String exerciseId)` ile alıyoruz.
/// Bu sınıf, tek bir egzersizin (exerciseId) set listesini yönetir.
///

abstract class _$UserExercise extends $AsyncNotifier<List<ExerciseSet>> {
  late final _$args = ref.$arg as String;
  String get exerciseId => _$args;

  FutureOr<List<ExerciseSet>> build(String exerciseId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<ExerciseSet>>, List<ExerciseSet>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ExerciseSet>>, List<ExerciseSet>>,
              AsyncValue<List<ExerciseSet>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
