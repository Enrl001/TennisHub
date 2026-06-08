import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
        throw Exception(_functionErrorMessage(response));
      }
      final data = response.data;
      if (data is! Map) {
        throw Exception('Invalid payment response');
      }
      final url = data['url'] as String?;
      if (url == null || url.isEmpty) {
        throw Exception(_functionErrorMessage(response));
      }
      state = AsyncData(url);
      return url;
    } catch (e, st) {
      state = AsyncError(_paymentErrorMessage(e), st);
      return null;
    }
  }

  String _functionErrorMessage(FunctionResponse response) {
    final data = response.data;
    if (data is Map) {
      final message = data['message'] ?? data['error'];
      if (message != null) return _shortenError(message.toString());
    }
    return _shortenError(response.data?.toString() ?? 'Invoice creation failed');
  }

  String _shortenError(String text) {
    if (text.contains('Account number is required')) {
      return 'Smartpay account number missing or invalid. In Supabase secrets, set SMARTPAY_ACCOUNT_NUMBER to your 8–12 digit merchant account.';
    }
    if (text.contains('SMARTPAY_ACCOUNT_NUMBER')) return text;
    if (text.startsWith('Exception: ')) text = text.substring(11);
    if (text.length > 180) return '${text.substring(0, 177)}...';
    return text;
  }

  String _paymentErrorMessage(Object error) {
    if (error is FunctionException && error.status == 404) {
      return 'Payment service is not deployed. Run: supabase functions deploy create-smartpay-invoice';
    }
    if (error is FunctionException) {
      final parsed = _parseFunctionException(error);
      if (parsed != null) return parsed;
      if (error.status == 502) {
        return 'Smartpay rejected the payment. Check credentials and use MNT prices (or set SMARTPAY_MNT_PER_USD for USD services).';
      }
      return error.reasonPhrase ?? error.toString();
    }
    final text = error.toString();
    if (text.contains('NOT_FOUND') && text.contains('function')) {
      return 'Payment service is not deployed. Deploy create-smartpay-invoice in Supabase Edge Functions.';
    }
    return _shortenError(text);
  }

  String? _parseFunctionException(FunctionException error) {
    final details = error.details;
    if (details is Map) {
      final message = details['message'] ?? details['error'];
      if (message != null) return message.toString();
    }
    final raw = error.toString();
    if (raw.contains('Smartpay is not configured')) {
      return 'Smartpay secrets missing. Set SMARTPAY_USERNAME, SMARTPAY_PASSWORD, SMARTPAY_ACCOUNT_NUMBER in Supabase.';
    }
    return null;
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

  /// Polls payment status (booking becomes confirmed via Smartpay webhook).
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
