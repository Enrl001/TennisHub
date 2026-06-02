import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/supabase_providers.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/providers/booking_provider.dart';
import '../../customer/providers/filter_provider.dart';

part 'coach_provider.g.dart';

/// Ensures int IDs from the DB are always treated as Strings before
/// passing to the generated fromJson code.
Map<String, dynamic> _fixCoachJson(Map<String, dynamic> json) {
  final m = Map<String, dynamic>.from(json);
  if (m['id'] != null) m['id'] = m['id'].toString();
  if (m['profile_id'] != null) m['profile_id'] = m['profile_id'].toString();
  if (m['services'] is List) {
    m['services'] = (m['services'] as List).map((s) {
      final sm = Map<String, dynamic>.from(s as Map);
      if (sm['id'] != null) sm['id'] = sm['id'].toString();
      if (sm['coach_id'] != null) sm['coach_id'] = sm['coach_id'].toString();
      return sm;
    }).toList();
  }
  return m;
}

Map<String, dynamic> _fixServiceJson(Map<String, dynamic> json) {
  final m = Map<String, dynamic>.from(json);
  if (m['id'] != null) m['id'] = m['id'].toString();
  if (m['coach_id'] != null) m['coach_id'] = m['coach_id'].toString();
  return m;
}

Map<String, dynamic> _fixTimeSlotJson(Map<String, dynamic> json) {
  final m = Map<String, dynamic>.from(json);
  if (m['id'] != null) m['id'] = m['id'].toString();
  if (m['coach_id'] != null) m['coach_id'] = m['coach_id'].toString();

  final service = m['service'];
  if (service is Map) {
    final fixedService = _fixServiceJson(Map<String, dynamic>.from(service));
    m['service'] = fixedService;
    m['service_id'] ??= fixedService['id'];
  }

  if (m['service_id'] != null) {
    m['service_id'] = m['service_id'].toString();
  } else {
    m['service_id'] = '';
  }
  return m;
}

@riverpod
Future<List<Coach>> coaches(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final filter = ref.watch(serviceTypeFilterProvider);
  final query = ref.watch(searchQueryProvider);

  final response = await client
      .from('coaches')
      .select('*, profile:profiles(*), services(*)')
      .eq('is_active', true)
      .order('avg_rating', ascending: false);

  var list = (response as List)
      .map((e) => Coach.fromJson(_fixCoachJson(e as Map<String, dynamic>)))
      .toList();

  if (filter != null) {
    list = list
        .where((c) => c.services?.any((s) => s.type == filter) ?? false)
        .toList();
  }
  if (query.isNotEmpty) {
    final q = query.toLowerCase();
    list = list
        .where(
          (c) =>
              (c.profile?.fullName ?? '').toLowerCase().contains(q) ||
              (c.bio ?? '').toLowerCase().contains(q) ||
              (c.location ?? '').toLowerCase().contains(q),
        )
        .toList();
  }
  return list;
}

@riverpod
Future<Coach> coachDetail(Ref ref, String coachId) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('coaches')
      .select('*, profile:profiles(*), services(*)')
      .eq('id', coachId)
      .single();
  return Coach.fromJson(_fixCoachJson(data));
}

@riverpod
Future<List<Review>> coachReviews(Ref ref, String coachId) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('reviews')
      .select('*, customer:profiles(*)')
      .eq('coach_id', coachId)
      .order('created_at', ascending: false);
  return (data as List).map((e) => Review.fromJson(e)).toList();
}

@riverpod
class CoachProfileNotifier extends _$CoachProfileNotifier {
  @override
  Future<void> build() async {}

  Future<String> ensureCoachRecord(String profileId) async {
    final client = ref.read(supabaseClientProvider);
    final existing = await client
        .from('coaches')
        .select('id')
        .eq('profile_id', profileId)
        .maybeSingle();
    if (existing != null) return existing['id'].toString();
    final created = await client
        .from('coaches')
        .insert({'profile_id': profileId})
        .select()
        .single();
    return created['id'].toString();
  }

  Future<void> updateCoachProfile(
    String coachId,
    Map<String, dynamic> updates,
  ) async {
    final client = ref.read(supabaseClientProvider);
    await client.from('coaches').update(updates).eq('id', coachId);
    if (!ref.mounted) return;
    ref.invalidate(coachDetailProvider(coachId));
    ref.invalidate(coachesProvider);
    ref.invalidate(myCoachProfileProvider);
  }

  Future<void> addService(Map<String, dynamic> serviceData) async {
    final client = ref.read(supabaseClientProvider);
    await client.from('services').insert(serviceData);
    if (!ref.mounted) return;
    ref.invalidate(coachesProvider);
    ref.invalidate(myCoachProfileProvider);
    ref.invalidate(myCoachServicesProvider);
  }

  Future<void> addTimeSlots(List<Map<String, dynamic>> slots) async {
    final client = ref.read(supabaseClientProvider);
    await client.from('time_slots').insert(slots);
    if (!ref.mounted) return;
    final serviceIds = slots
        .map((slot) => slot['service_id']?.toString())
        .whereType<String>()
        .toSet();
    for (final serviceId in serviceIds) {
      ref.invalidate(serviceSlotsProvider(serviceId));
    }
    ref.invalidate(myCoachSlotsProvider);
    ref.invalidate(myCoachProfileProvider);
    ref.invalidate(myCoachServicesProvider);
  }
}

/// Loads the current logged-in coach's own record (by profile_id).
/// Does NOT filter by is_active so the coach always sees their own data.
final myCoachProfileProvider = FutureProvider<Coach?>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final profile = ref.watch(currentProfileProvider);
  if (profile == null) return null;
  final data = await client
      .from('coaches')
      .select('*, profile:profiles(*)')
      .eq('profile_id', profile.id)
      .maybeSingle();
  if (data == null) return null;
  return Coach.fromJson(_fixCoachJson(data));
});

final myCoachServicesProvider = FutureProvider<List<Service>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final profile = ref.watch(currentProfileProvider);
  if (profile == null) return [];

  final coachRow = await client
      .from('coaches')
      .select('id')
      .eq('profile_id', profile.id)
      .maybeSingle();
  if (coachRow == null) return [];
  final coachId = coachRow['id'].toString();

  final data = await client
      .from('services')
      .select()
      .eq('coach_id', coachId)
      .eq('is_active', true)
      .order('title');
  return (data as List)
      .map((e) => Service.fromJson(_fixServiceJson(e as Map<String, dynamic>)))
      .toList();
});

/// Loads all (non-cancelled) time slots for the current coach.
final myCoachSlotsProvider = FutureProvider<List<TimeSlot>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final profile = ref.watch(currentProfileProvider);
  if (profile == null) return [];

  final coachRow = await client
      .from('coaches')
      .select('id')
      .eq('profile_id', profile.id)
      .maybeSingle();
  if (coachRow == null) return [];
  final coachId = coachRow['id'].toString();

  final data = await client
      .from('time_slots')
      .select('*, service:services(*)')
      .eq('coach_id', coachId)
      .eq('is_cancelled', false)
      .gte(
        'starts_at',
        DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
      )
      .order('starts_at');
  return (data as List)
      .map(
        (e) => TimeSlot.fromJson(
          _fixTimeSlotJson(Map<String, dynamic>.from(e as Map)),
        ),
      )
      .toList();
});

@riverpod
Future<List<TimeSlot>> coachUpcomingSlots(Ref ref, String coachId) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('time_slots')
      .select('*, service:services(*)')
      .eq('coach_id', coachId)
      .eq('is_cancelled', false)
      .gte('starts_at', DateTime.now().toIso8601String())
      .order('starts_at');
  return (data as List)
      .map(
        (e) => TimeSlot.fromJson(
          _fixTimeSlotJson(Map<String, dynamic>.from(e as Map)),
        ),
      )
      .toList();
}
