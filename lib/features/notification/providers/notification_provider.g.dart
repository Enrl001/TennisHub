// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationsStream)
final notificationsStreamProvider = NotificationsStreamProvider._();

final class NotificationsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppNotification>>,
          List<AppNotification>,
          Stream<List<AppNotification>>
        >
    with
        $FutureModifier<List<AppNotification>>,
        $StreamProvider<List<AppNotification>> {
  NotificationsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<AppNotification>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AppNotification>> create(Ref ref) {
    return notificationsStream(ref);
  }
}

String _$notificationsStreamHash() =>
    r'a88d7ca98c172b69ace5fe1da937af2edd170df8';

@ProviderFor(unreadCount)
final unreadCountProvider = UnreadCountProvider._();

final class UnreadCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  UnreadCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return unreadCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unreadCountHash() => r'049ce559ad3a97b5649a1de0f903f9fa8479dbc3';

@ProviderFor(HandledBookingNotifications)
final handledBookingNotificationsProvider =
    HandledBookingNotificationsProvider._();

final class HandledBookingNotificationsProvider
    extends $NotifierProvider<HandledBookingNotifications, Set<String>> {
  HandledBookingNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'handledBookingNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$handledBookingNotificationsHash();

  @$internal
  @override
  HandledBookingNotifications create() => HandledBookingNotifications();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$handledBookingNotificationsHash() =>
    r'dc029c0404e5e791dec6317b01caaaac7e848b6b';

abstract class _$HandledBookingNotifications extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(NotificationActions)
final notificationActionsProvider = NotificationActionsProvider._();

final class NotificationActionsProvider
    extends $NotifierProvider<NotificationActions, void> {
  NotificationActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationActionsHash();

  @$internal
  @override
  NotificationActions create() => NotificationActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$notificationActionsHash() =>
    r'36e1d29f084a8fc2bbd2425111dd2dc3df7b4715';

abstract class _$NotificationActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
