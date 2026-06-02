import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/providers/supabase_providers.dart';

part 'payment_provider.g.dart';

/// Whether Smartpay has marked this booking as paid.
final bookingPaidProvider = FutureProvider.family<bool, String>((
  ref,
  bookingId,
) async {
  return ref.read(paymentProvider.notifier).isBookingPaid(bookingId);
});

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

  /// True when Smartpay webhook marked the payment as paid.
  Future<bool> isBookingPaid(String bookingId) async {
    final client = ref.read(supabaseClientProvider);
    final rows = await client
        .from('payments')
        .select('status')
        .eq('booking_id', bookingId)
        .order('created_at', ascending: false)
        .limit(1);
    if (rows.isEmpty) return false;
    return rows.first['status'] == 'paid';
  }

  /// Polls payment status (not booking status — group lessons can be
  /// confirmed before payment completes).
  Future<bool> checkPaymentComplete(String bookingId) async {
    return isBookingPaid(bookingId);
  }

  Future<String?> bookingStatus(String bookingId) async {
    final client = ref.read(supabaseClientProvider);
    final data = await client
        .from('bookings')
        .select('status')
        .eq('id', bookingId)
        .single();
    return data['status'] as String?;
  }
}
