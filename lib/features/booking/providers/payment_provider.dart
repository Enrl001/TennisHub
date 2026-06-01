import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/providers/supabase_providers.dart';

part 'payment_provider.g.dart';

/// Holds the Smartpay invoice URL returned after invoice creation.
/// `null` = not yet created / loading cleared.
@riverpod
class PaymentNotifier extends _$PaymentNotifier {
  @override
  AsyncValue<String?> build() => const AsyncData(null);

  /// Calls the `create-smartpay-invoice` Edge Function.
  /// On success, stores the Smartpay checkout URL in state and returns it.
  Future<String?> createSmartpayInvoice({
    required String bookingId,
    required double amount,
    required String description,
    String? phone,
  }) async {
    state = const AsyncLoading();
    try {
      final client = ref.read(supabaseClientProvider);
      final response = await client.functions.invoke(
        'create-smartpay-invoice',
        body: {
          'bookingId': bookingId,
          'amount': amount.round(),
          'description': description,
          if (phone != null) 'phone': phone,
        },
      );
      if (response.status != 200) {
        throw Exception(response.data?.toString() ?? 'Invoice creation failed');
      }
      final url = response.data['url'] as String;
      state = AsyncData(url);
      return url;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  /// Polls Supabase for the booking's current status.
  /// The webhook updates it to 'confirmed' once Smartpay notifies payment.
  Future<String?> checkBookingStatus(String bookingId) async {
    final client = ref.read(supabaseClientProvider);
    final data = await client
        .from('bookings')
        .select('status')
        .eq('id', bookingId)
        .single();
    return data['status'] as String?;
  }
}
