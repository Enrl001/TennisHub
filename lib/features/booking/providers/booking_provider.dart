import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../booking_flow.dart';
import '../../coach/providers/coach_provider.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/supabase_providers.dart';

part 'booking_provider.g.dart';

Map<String, dynamic> _fixServiceJson(Map<String, dynamic> json) {
  final m = Map<String, dynamic>.from(json);
  if (m['id'] != null) m['id'] = coerceEntityId(m['id']);
  if (m['coach_id'] != null) m['coach_id'] = coerceEntityId(m['coach_id']);
  return m;
}

Map<String, dynamic> _fixTimeSlotJson(
  Map<String, dynamic> json, {
  String? fallbackServiceId,
}) {
  final m = Map<String, dynamic>.from(json);
  if (m['id'] != null) m['id'] = coerceEntityId(m['id']);
  if (m['coach_id'] != null) m['coach_id'] = coerceEntityId(m['coach_id']);

  final service = m['service'];
  if (service is Map) {
    final fixedService = _fixServiceJson(Map<String, dynamic>.from(service));
    m['service'] = fixedService;
    m['service_id'] ??= fixedService['id'];
  }
  m['service_id'] ??= fallbackServiceId;
  if (m['service_id'] != null) {
    m['service_id'] = coerceEntityId(m['service_id']);
  }
  return m;
}

Map<String, dynamic> _fixBookingJson(Map<String, dynamic> json) {
  final m = Map<String, dynamic>.from(json);
  for (final key in [
    'id',
    'slot_id',
    'service_id',
    'coach_id',
    'customer_id',
  ]) {
    if (m[key] != null) m[key] = coerceEntityId(m[key]);
  }
  if (m['slot'] is Map) {
    m['slot'] = _fixTimeSlotJson(
      Map<String, dynamic>.from(m['slot'] as Map),
      fallbackServiceId: m['service_id']?.toString(),
    );
  }
  if (m['service'] is Map) {
    m['service'] = _fixServiceJson(
      Map<String, dynamic>.from(m['service'] as Map),
    );
  }
  if (m['coach'] is Map) {
    final coach = Map<String, dynamic>.from(m['coach'] as Map);
    if (coach['id'] != null) coach['id'] = coerceEntityId(coach['id']);
    if (coach['profile_id'] != null) {
      coach['profile_id'] = coerceEntityId(coach['profile_id']);
    }
    m['coach'] = coach;
  }
  return m;
}

@riverpod
Future<List<TimeSlot>> serviceSlots(Ref ref, String serviceId) async {
  final client = ref.watch(supabaseClientProvider);
  final resolvedServiceId = tryResolveUuid(serviceId) ?? serviceId.trim();
  final serviceRow = await client
      .from('services')
      .select('id, coach_id')
      .eq('id', resolvedServiceId)
      .single();
  final coachId = serviceRow['coach_id'].toString();

  final data = await client
      .from('time_slots')
      .select('*, service:services(*)')
      .eq('coach_id', coachId)
      .eq('is_cancelled', false)
      .gte('ends_at', DateTime.now().toIso8601String())
      .order('starts_at');
  return (data as List)
      .where((e) {
        final slotServiceId = (e as Map)['service_id']?.toString();
        return slotServiceId == null || slotServiceId == resolvedServiceId;
      })
      .map((e) {
        final slotJson = Map<String, dynamic>.from(e as Map);
        return TimeSlot.fromJson(
          _fixTimeSlotJson(slotJson, fallbackServiceId: resolvedServiceId),
        );
      })
      .toList();
}

final serviceDetailProvider = FutureProvider.family<Service?, String>((
  ref,
  serviceId,
) async {
  final client = ref.watch(supabaseClientProvider);
  final resolvedId = tryResolveUuid(serviceId) ?? serviceId.trim();
  final data = await client
      .from('services')
      .select()
      .eq('id', resolvedId)
      .maybeSingle();
  if (data == null) return null;
  return Service.fromJson(_fixServiceJson(Map<String, dynamic>.from(data)));
});

@riverpod
Future<List<Booking>> myBookings(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) return [];
  final data = await client
      .from('bookings')
      .select(
        '*, slot:time_slots(*, service:services(*)), service:services(*), coach:coaches(*, profile:profiles(*))',
      )
      .eq('customer_id', user.id)
      .order('created_at', ascending: false);
  return (data as List)
      .map((e) => Booking.fromJson(_fixBookingJson(e as Map<String, dynamic>)))
      .toList();
}

@riverpod
Future<List<Booking>> coachCalendarBookings(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) return [];
  final coachRow = await client
      .from('coaches')
      .select('id')
      .eq('profile_id', user.id)
      .maybeSingle();
  if (coachRow == null) return [];
  final coachId = coachRow['id'].toString();
  final data = await client
      .from('bookings')
      .select(
        '*, slot:time_slots(*, service:services(*)), service:services(*), customer:profiles(*)',
      )
      .eq('coach_id', coachId)
      .inFilter('status', ['pending', 'confirmed'])
      .order('created_at', ascending: false);
  return (data as List)
      .map((e) => Booking.fromJson(_fixBookingJson(e as Map<String, dynamic>)))
      .toList();
}

@riverpod
Future<List<Booking>> coachBookings(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) return [];
  // bookings.coach_id references coaches.id (not profiles.id), so look it up first
  final coachRow = await client
      .from('coaches')
      .select('id')
      .eq('profile_id', user.id)
      .maybeSingle();
  if (coachRow == null) return [];
  final coachId = coachRow['id'].toString();
  final data = await client
      .from('bookings')
      .select(
        '*, slot:time_slots(*), service:services(*), customer:profiles(*)',
      )
      .eq('coach_id', coachId)
      .order('created_at', ascending: false);
  return (data as List)
      .map((e) => Booking.fromJson(_fixBookingJson(e as Map<String, dynamic>)))
      .toList();
}

const _bookingDetailSelect =
    '*, slot:time_slots(*, service:services(*)), service:services(*), '
    'customer:profiles(*), coach:coaches(*, profile:profiles(*))';

final bookingDetailProvider = FutureProvider.family<Booking?, String>((
  ref,
  bookingId,
) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('bookings')
      .select(_bookingDetailSelect)
      .eq('id', bookingId)
      .maybeSingle();
  if (data == null) return null;
  return Booking.fromJson(_fixBookingJson(Map<String, dynamic>.from(data)));
});

final slotSessionProvider = FutureProvider.family<TimeSlot?, String>((
  ref,
  slotId,
) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('time_slots')
      .select('*, service:services(*)')
      .eq('id', slotId)
      .maybeSingle();
  if (data == null) return null;
  return TimeSlot.fromJson(
    _fixTimeSlotJson(Map<String, dynamic>.from(data)),
  );
});

final slotBookingsProvider = FutureProvider.family<List<Booking>, String>((
  ref,
  slotId,
) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('bookings')
      .select(_bookingDetailSelect)
      .eq('slot_id', slotId)
      .inFilter('status', ['pending', 'confirmed', 'completed'])
      .order('created_at');
  return (data as List)
      .map((e) => Booking.fromJson(_fixBookingJson(e as Map<String, dynamic>)))
      .toList();
});

final bookingReviewProvider = FutureProvider.family<Review?, String>((
  ref,
  bookingId,
) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('reviews')
      .select('*, customer:profiles(*)')
      .eq('booking_id', bookingId)
      .maybeSingle();
  if (data == null) return null;
  return Review.fromJson(Map<String, dynamic>.from(data));
});

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

    await _ensureCustomerProfile(client, user.id);

    final resolvedServiceId = tryResolveUuid(serviceId) ?? serviceId.trim();
    final slotQueryId = tryResolveUuid(slotId) ?? slotId.trim();

    var slotRow = await client
        .from('time_slots')
        .select('*, service:services(*)')
        .eq('id', slotQueryId)
        .eq('is_cancelled', false)
        .maybeSingle();
    if (slotRow == null && slotQueryId != slotId.trim()) {
      slotRow = await client
          .from('time_slots')
          .select('*, service:services(*)')
          .eq('id', slotId.trim())
          .eq('is_cancelled', false)
          .maybeSingle();
    }
    if (slotRow == null) {
      if (ref.mounted) ref.invalidate(serviceSlotsProvider(resolvedServiceId));
      throw Exception('time_slot_unavailable');
    }

    final slotMap = Map<String, dynamic>.from(slotRow);
    final rpcSlotId = tryResolveUuid(coerceEntityId(slotMap['id']));
    if (rpcSlotId == null) {
      if (ref.mounted) ref.invalidate(serviceSlotsProvider(resolvedServiceId));
      throw Exception('time_slot_unavailable');
    }

    var rpcServiceId = tryResolveUuid(
      coerceEntityId(slotMap['service_id'] ?? slotMap['service']?['id']),
    );
    rpcServiceId ??= tryResolveUuid(resolvedServiceId);
    if (rpcServiceId == null) {
      if (ref.mounted) ref.invalidate(serviceSlotsProvider(resolvedServiceId));
      throw Exception('time_slot_unavailable');
    }

    var rpcCoachId = tryResolveUuid(coerceEntityId(slotMap['coach_id']));
    rpcCoachId ??= tryResolveUuid(
      coerceEntityId(slotMap['service']?['coach_id']),
    );
    rpcCoachId ??= tryResolveUuid(coachId);
    if (rpcCoachId == null) {
      final serviceRow = await client
          .from('services')
          .select('coach_id')
          .eq('id', rpcServiceId)
          .maybeSingle();
      rpcCoachId = tryResolveUuid(coerceEntityId(serviceRow?['coach_id']));
    }
    if (rpcCoachId == null) {
      if (kDebugMode) {
        debugPrint(
          'Could not resolve coach id for slot=$rpcSlotId service=$rpcServiceId',
        );
      }
      throw Exception('time_slot_unavailable');
    }

    final dbSlotId = rpcSlotId;
    final dbServiceId = rpcServiceId;
    final dbCoachId = rpcCoachId;

    final slot = TimeSlot.fromJson(
      _fixTimeSlotJson(slotMap, fallbackServiceId: dbServiceId),
    );
    final service =
        slot.service ??
        Service.fromJson(
          _fixServiceJson(
            Map<String, dynamic>.from(
              await client
                  .from('services')
                  .select()
                  .eq('id', dbServiceId)
                  .single(),
            ),
          ),
        );
    final maxParticipants = service.maxParticipants ?? 1;
    if (slot.bookedCount >= maxParticipants) {
      if (ref.mounted) ref.invalidate(serviceSlotsProvider(dbServiceId));
      throw Exception('time_slot_full');
    }

    late final String bookingId;
    try {
      final result = await client.rpc(
        'create_customer_booking',
        params: {
          'p_slot_id': rpcSlotId,
          'p_service_id': rpcServiceId,
          'p_coach_id': rpcCoachId,
          'p_amount': amount,
          'p_currency': currency,
        },
      );
      bookingId = await _parseBookingIdFromRpc(
        client,
        result,
        slotId: rpcSlotId,
        customerId: user.id,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('createBooking RPC failed: $e\n$st');
      }
      if (ref.mounted) ref.invalidate(serviceSlotsProvider(dbServiceId));
      throw _mapBookingCreateError(e);
    }

    Map<String, dynamic> data;
    try {
      final row = await client
          .from('bookings')
          .select('*, slot:time_slots(*, service:services(*))')
          .eq('id', bookingId)
          .single();
      data = Map<String, dynamic>.from(row);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('createBooking fetch failed (booking $bookingId exists): $e\n$st');
      }
      data = {
        'id': bookingId,
        'slot_id': dbSlotId,
        'service_id': dbServiceId,
        'coach_id': dbCoachId,
        'customer_id': user.id,
        'status': amount <= 0 ? 'confirmed' : 'pending',
        'amount_paid': amount,
        'currency': currency,
        'slot': slotRow,
      };
    }

    if (!ref.mounted) {
      return Booking.fromJson(_fixBookingJson(data));
    }
    ref.invalidate(myBookingsProvider);
    ref.invalidate(serviceSlotsProvider(dbServiceId));
    ref.invalidate(coachBookingsProvider);
    ref.invalidate(coachCalendarBookingsProvider);
    return Booking.fromJson(_fixBookingJson(data));
  }

  Future<void> cancelBooking(String bookingId) async {
    final client = ref.read(supabaseClientProvider);
    await client
        .from('bookings')
        .update({'status': 'cancelled'})
        .eq('id', bookingId);
    if (!ref.mounted) return;
    ref.invalidate(myBookingsProvider);
    ref.invalidate(coachBookingsProvider);
    ref.invalidate(coachCalendarBookingsProvider);
    ref.invalidate(bookingDetailProvider(bookingId));
  }

  Future<void> approveBooking(String bookingId) async {
    final client = ref.read(supabaseClientProvider);
    await client
        .from('bookings')
        .update({'status': 'confirmed'})
        .eq('id', bookingId);
    if (!ref.mounted) return;
    ref.invalidate(myBookingsProvider);
    ref.invalidate(coachBookingsProvider);
    ref.invalidate(coachCalendarBookingsProvider);
    ref.invalidate(bookingDetailProvider(bookingId));
  }

  Future<void> rejectBooking(String bookingId) async {
    final client = ref.read(supabaseClientProvider);
    await client
        .from('bookings')
        .update({'status': 'cancelled'})
        .eq('id', bookingId);
    if (!ref.mounted) return;
    ref.invalidate(myBookingsProvider);
    ref.invalidate(coachBookingsProvider);
    ref.invalidate(coachCalendarBookingsProvider);
    ref.invalidate(bookingDetailProvider(bookingId));
  }

  Future<void> submitReview({
    required String bookingId,
    required String coachId,
    required int rating,
    String? comment,
  }) async {
    final client = ref.read(supabaseClientProvider);
    final user = client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await client.from('reviews').insert({
      'booking_id': bookingId,
      'coach_id': coachId,
      'customer_id': user.id,
      'rating': rating,
      'comment': comment?.trim().isEmpty ?? true ? null : comment?.trim(),
    });

    if (!ref.mounted) return;
    ref.invalidate(bookingReviewProvider(bookingId));
    ref.invalidate(coachReviewsProvider(coachId));
    ref.invalidate(coachDetailProvider(coachId));
  }
}

Future<void> _ensureCustomerProfile(SupabaseClient client, String userId) async {
  final existing = await client
      .from('profiles')
      .select('id')
      .eq('id', userId)
      .maybeSingle();
  if (existing != null) return;
  await client.rpc('create_profile', params: {
    'p_user_id': userId,
    'p_user_role': 'customer',
  });
}

Exception _mapBookingCreateError(Object error) {
  final message = error is PostgrestException
      ? '${error.message} ${error.details ?? ''} ${error.hint ?? ''}'
      : error.toString();
  final normalized = message.toLowerCase();
  if (message.contains('time_slot_unavailable') ||
      message.contains('Time slot not found') ||
      (normalized.contains('foreign key') && normalized.contains('slot_id'))) {
    return Exception('time_slot_unavailable');
  }
  if (message.contains('time_slot_full') ||
      message.contains('Not enough available places') ||
      message.contains('already full')) {
    return Exception('time_slot_full');
  }
  if (normalized.contains('profiles') &&
      (normalized.contains('foreign key') ||
          normalized.contains('violates'))) {
    return Exception('profile_missing');
  }
  if (normalized.contains('row-level security') ||
      normalized.contains('permission denied')) {
    return Exception('booking_permission_denied');
  }
  if (normalized.contains('function') &&
      normalized.contains('create_customer_booking') &&
      (normalized.contains('does not exist') || normalized.contains('could not find'))) {
    return Exception('booking_rpc_missing');
  }
  if (message.contains('Coach does not match')) {
    return Exception('time_slot_unavailable');
  }
  if (message.contains('invalid_booking_ids') ||
      normalized.contains('invalid input syntax for type uuid')) {
    return Exception('invalid_booking_ids');
  }
  return Exception('booking_failed:$message');
}

Future<String> _parseBookingIdFromRpc(
  SupabaseClient client,
  dynamic result, {
  required String slotId,
  required String customerId,
}) async {
  final direct = _bookingIdFromRpcValue(result);
  if (direct != null) return direct;

  if (kDebugMode) {
    debugPrint(
      'RPC returned unexpected booking id ($result); looking up latest booking',
    );
  }
  final recent = await client
      .from('bookings')
      .select('id')
      .eq('customer_id', customerId)
      .eq('slot_id', slotId)
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();
  final recovered = _bookingIdFromRpcValue(recent?['id']);
  if (recovered != null) return recovered;

  throw Exception('invalid_booking_id:${result.toString()}');
}

String? _bookingIdFromRpcValue(dynamic value) {
  if (value == null) return null;
  if (value is Map) {
    final nested =
        value['id'] ?? value['booking_id'] ?? value['create_customer_booking'];
    return _bookingIdFromRpcValue(nested);
  }
  if (value is List && value.isNotEmpty) {
    return _bookingIdFromRpcValue(value.first);
  }
  final raw = coerceEntityId(value);
  return tryResolveUuid(raw);
}
