// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(coaches)
final coachesProvider = CoachesProvider._();

final class CoachesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Coach>>,
          List<Coach>,
          FutureOr<List<Coach>>
        >
    with $FutureModifier<List<Coach>>, $FutureProvider<List<Coach>> {
  CoachesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coachesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coachesHash();

  @$internal
  @override
  $FutureProviderElement<List<Coach>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Coach>> create(Ref ref) {
    return coaches(ref);
  }
}

String _$coachesHash() => r'8308c9bf008a4e4417d3a856a16348fc6617a4a2';

@ProviderFor(coachDetail)
final coachDetailProvider = CoachDetailFamily._();

final class CoachDetailProvider
    extends $FunctionalProvider<AsyncValue<Coach>, Coach, FutureOr<Coach>>
    with $FutureModifier<Coach>, $FutureProvider<Coach> {
  CoachDetailProvider._({
    required CoachDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'coachDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coachDetailHash();

  @override
  String toString() {
    return r'coachDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Coach> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Coach> create(Ref ref) {
    final argument = this.argument as String;
    return coachDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CoachDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coachDetailHash() => r'c67e398cc3040d9ce07a6a3f6beba39e068c20c0';

final class CoachDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Coach>, String> {
  CoachDetailFamily._()
    : super(
        retry: null,
        name: r'coachDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CoachDetailProvider call(String coachId) =>
      CoachDetailProvider._(argument: coachId, from: this);

  @override
  String toString() => r'coachDetailProvider';
}

@ProviderFor(coachReviews)
final coachReviewsProvider = CoachReviewsFamily._();

final class CoachReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Review>>,
          List<Review>,
          FutureOr<List<Review>>
        >
    with $FutureModifier<List<Review>>, $FutureProvider<List<Review>> {
  CoachReviewsProvider._({
    required CoachReviewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'coachReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coachReviewsHash();

  @override
  String toString() {
    return r'coachReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Review>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Review>> create(Ref ref) {
    final argument = this.argument as String;
    return coachReviews(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CoachReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coachReviewsHash() => r'798f17f906e020d3baffa238fdc661638ed84bd2';

final class CoachReviewsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Review>>, String> {
  CoachReviewsFamily._()
    : super(
        retry: null,
        name: r'coachReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CoachReviewsProvider call(String coachId) =>
      CoachReviewsProvider._(argument: coachId, from: this);

  @override
  String toString() => r'coachReviewsProvider';
}

@ProviderFor(CoachProfileNotifier)
final coachProfileProvider = CoachProfileNotifierProvider._();

final class CoachProfileNotifierProvider
    extends $AsyncNotifierProvider<CoachProfileNotifier, void> {
  CoachProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coachProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coachProfileNotifierHash();

  @$internal
  @override
  CoachProfileNotifier create() => CoachProfileNotifier();
}

String _$coachProfileNotifierHash() =>
    r'767b9f637e11877028cbd3fe32595b1a30d72525';

abstract class _$CoachProfileNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(coachUpcomingSlots)
final coachUpcomingSlotsProvider = CoachUpcomingSlotsFamily._();

final class CoachUpcomingSlotsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TimeSlot>>,
          List<TimeSlot>,
          FutureOr<List<TimeSlot>>
        >
    with $FutureModifier<List<TimeSlot>>, $FutureProvider<List<TimeSlot>> {
  CoachUpcomingSlotsProvider._({
    required CoachUpcomingSlotsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'coachUpcomingSlotsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coachUpcomingSlotsHash();

  @override
  String toString() {
    return r'coachUpcomingSlotsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<TimeSlot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TimeSlot>> create(Ref ref) {
    final argument = this.argument as String;
    return coachUpcomingSlots(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CoachUpcomingSlotsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coachUpcomingSlotsHash() =>
    r'2b436a5ea6682766e2c7b33ead4627f0b9291f85';

final class CoachUpcomingSlotsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<TimeSlot>>, String> {
  CoachUpcomingSlotsFamily._()
    : super(
        retry: null,
        name: r'coachUpcomingSlotsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CoachUpcomingSlotsProvider call(String coachId) =>
      CoachUpcomingSlotsProvider._(argument: coachId, from: this);

  @override
  String toString() => r'coachUpcomingSlotsProvider';
}
