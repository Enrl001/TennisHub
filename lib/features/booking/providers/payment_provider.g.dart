// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the Smartpay invoice URL returned after invoice creation.
/// `null` = not yet created / loading cleared.

@ProviderFor(PaymentNotifier)
final paymentProvider = PaymentNotifierProvider._();

/// Holds the Smartpay invoice URL returned after invoice creation.
/// `null` = not yet created / loading cleared.
final class PaymentNotifierProvider
    extends $NotifierProvider<PaymentNotifier, AsyncValue<String?>> {
  /// Holds the Smartpay invoice URL returned after invoice creation.
  /// `null` = not yet created / loading cleared.
  PaymentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentNotifierHash();

  @$internal
  @override
  PaymentNotifier create() => PaymentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<String?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<String?>>(value),
    );
  }
}

String _$paymentNotifierHash() => r'6266d9eaad74cb8443a847cfb43793d699c4f830';

/// Holds the Smartpay invoice URL returned after invoice creation.
/// `null` = not yet created / loading cleared.

abstract class _$PaymentNotifier extends $Notifier<AsyncValue<String?>> {
  AsyncValue<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, AsyncValue<String?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, AsyncValue<String?>>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
