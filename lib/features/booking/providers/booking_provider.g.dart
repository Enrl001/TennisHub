// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(serviceSlots)
final serviceSlotsProvider = ServiceSlotsFamily._();

final class ServiceSlotsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TimeSlot>>,
          List<TimeSlot>,
          FutureOr<List<TimeSlot>>
        >
    with $FutureModifier<List<TimeSlot>>, $FutureProvider<List<TimeSlot>> {
  ServiceSlotsProvider._({
    required ServiceSlotsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'serviceSlotsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceSlotsHash();

  @override
  String toString() {
    return r'serviceSlotsProvider'
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
    return serviceSlots(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceSlotsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceSlotsHash() => r'6d8eeb727dadb575f0998c8cf4ed45035ef2fff7';

final class ServiceSlotsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<TimeSlot>>, String> {
  ServiceSlotsFamily._()
    : super(
        retry: null,
        name: r'serviceSlotsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ServiceSlotsProvider call(String serviceId) =>
      ServiceSlotsProvider._(argument: serviceId, from: this);

  @override
  String toString() => r'serviceSlotsProvider';
}

@ProviderFor(myBookings)
final myBookingsProvider = MyBookingsProvider._();

final class MyBookingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Booking>>,
          List<Booking>,
          FutureOr<List<Booking>>
        >
    with $FutureModifier<List<Booking>>, $FutureProvider<List<Booking>> {
  MyBookingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myBookingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myBookingsHash();

  @$internal
  @override
  $FutureProviderElement<List<Booking>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Booking>> create(Ref ref) {
    return myBookings(ref);
  }
}

String _$myBookingsHash() => r'bfa1d29934a301dc68b04e74ac5cd46c09ca3afb';

@ProviderFor(coachBookings)
final coachBookingsProvider = CoachBookingsProvider._();

final class CoachBookingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Booking>>,
          List<Booking>,
          FutureOr<List<Booking>>
        >
    with $FutureModifier<List<Booking>>, $FutureProvider<List<Booking>> {
  CoachBookingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coachBookingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coachBookingsHash();

  @$internal
  @override
  $FutureProviderElement<List<Booking>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Booking>> create(Ref ref) {
    return coachBookings(ref);
  }
}

String _$coachBookingsHash() => r'1df6fc0cbbc11d8ebab59d972145c1981ebd7b3c';

@ProviderFor(BookingNotifier)
final bookingProvider = BookingNotifierProvider._();

final class BookingNotifierProvider
    extends $AsyncNotifierProvider<BookingNotifier, void> {
  BookingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingNotifierHash();

  @$internal
  @override
  BookingNotifier create() => BookingNotifier();
}

String _$bookingNotifierHash() => r'5fff81d846a1284d0183a9842a02234b01560993';

abstract class _$BookingNotifier extends $AsyncNotifier<void> {
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
