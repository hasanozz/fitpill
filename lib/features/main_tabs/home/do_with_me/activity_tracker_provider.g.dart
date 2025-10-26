// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_tracker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActivityTracker)
const activityTrackerProvider = ActivityTrackerFamily._();

final class ActivityTrackerProvider
    extends $NotifierProvider<ActivityTracker, ActivityTrackerState> {
  const ActivityTrackerProvider._({
    required ActivityTrackerFamily super.from,
    required ActivityTrackerParams super.argument,
  }) : super(
         retry: null,
         name: r'activityTrackerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityTrackerHash();

  @override
  String toString() {
    return r'activityTrackerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityTracker create() => ActivityTracker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityTrackerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityTrackerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityTrackerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityTrackerHash() => r'189bdcf86eec0abe02e01edcde539381ac89cfbc';

final class ActivityTrackerFamily extends $Family
    with
        $ClassFamilyOverride<
          ActivityTracker,
          ActivityTrackerState,
          ActivityTrackerState,
          ActivityTrackerState,
          ActivityTrackerParams
        > {
  const ActivityTrackerFamily._()
    : super(
        retry: null,
        name: r'activityTrackerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActivityTrackerProvider call(ActivityTrackerParams params) =>
      ActivityTrackerProvider._(argument: params, from: this);

  @override
  String toString() => r'activityTrackerProvider';
}

abstract class _$ActivityTracker extends $Notifier<ActivityTrackerState> {
  late final _$args = ref.$arg as ActivityTrackerParams;
  ActivityTrackerParams get params => _$args;

  ActivityTrackerState build(ActivityTrackerParams params);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<ActivityTrackerState, ActivityTrackerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActivityTrackerState, ActivityTrackerState>,
              ActivityTrackerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
