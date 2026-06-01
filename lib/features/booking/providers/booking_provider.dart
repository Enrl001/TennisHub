import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/supabase_providers.dart';

part 'booking_provider.g.dart';

@riverpod
Future<List<TimeSlot>> serviceSlots(
    Ref ref, String serviceId) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('time_slots')
      .select('*, service:services(*)')
      .eq('service_id', serviceId)
      .eq('is_cancelled', false)
      .gte('starts_at', DateTime.now().toIso8601String())
      .order('starts_at');
  return (data as List).map((e) => TimeSlot.fromJson(e)).toList();
}

@riverpod
Future<List<Booking>> myBookings(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) return [];
  final data = await client
      .from('bookings')
      .select(
          '*, slot:time_slots(*, service:services(*)), coach:coaches(*, profile:profiles(*))')
      .eq('customer_id', user.id)
      .order('created_at', ascending: false);
  return (data as List).map((e) => Booking.fromJson(e)).toList();
}

@riverpod
Future<List<Booking>> coachBookings(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) return [];
  final data = await client
      .from('bookings')
      .select('*, slot:time_slots(*), service:services(*), customer:profiles(*)')
      .eq('coach_id', user.id)
      .order('created_at', ascending: false);
  return (data as List).map((e) => Booking.fromJson(e)).toList();
}

@riverpod
class BookingNotifier extends _$BookingNotifier {
  @override
  Future<void> build() async {}

  Future<Booking> createBooking({
    required String slotId,
    required String serviceId,
    required String coachId,
    required double amount,
    required String currency,
  }) async {
    final client = ref.read(supabaseClientProvider);
    final user = client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final data = await client.from('bookings').insert({
      'slot_id': slotId,
      'service_id': serviceId,
      'coach_id': coachId,
      'customer_id': user.id,
      'status': 'pending',
      'amount_paid': amount,
      'currency': currency,
    }).select('*, slot:time_slots(*, service:services(*))').single();

    ref.invalidate(myBookingsProvider);
    return Booking.fromJson(data);
  }

  Future<void> cancelBooking(String bookingId) async {
    final client = ref.read(supabaseClientProvider);
    await client
        .from('bookings')
        .update({'status': 'cancelled'}).eq('id', bookingId);
    ref.invalidate(myBookingsProvider);
    ref.invalidate(coachBookingsProvider);
  }
}
