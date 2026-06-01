import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/supabase_providers.dart';
import '../../customer/providers/filter_provider.dart';

part 'coach_provider.g.dart';

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

  var list = (response as List).map((e) => Coach.fromJson(e)).toList();

  if (filter != null) {
    list = list
        .where(
            (c) => c.services?.any((s) => s.type == filter) ?? false)
        .toList();
  }
  if (query.isNotEmpty) {
    final q = query.toLowerCase();
    list = list
        .where((c) =>
            (c.profile?.fullName ?? '').toLowerCase().contains(q) ||
            (c.bio ?? '').toLowerCase().contains(q) ||
            (c.location ?? '').toLowerCase().contains(q))
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
  return Coach.fromJson(data);
}

@riverpod
Future<List<Review>> coachReviews(
    Ref ref, String coachId) async {
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
    if (existing != null) return existing['id'] as String;
    final created = await client
        .from('coaches')
        .insert({'profile_id': profileId})
        .select()
        .single();
    return created['id'] as String;
  }

  Future<void> updateCoachProfile(
      String coachId, Map<String, dynamic> updates) async {
    final client = ref.read(supabaseClientProvider);
    await client.from('coaches').update(updates).eq('id', coachId);
    ref.invalidate(coachDetailProvider(coachId));
    ref.invalidate(coachesProvider);
  }

  Future<void> addService(Map<String, dynamic> serviceData) async {
    final client = ref.read(supabaseClientProvider);
    await client.from('services').insert(serviceData);
    ref.invalidate(coachesProvider);
  }

  Future<void> addTimeSlots(List<Map<String, dynamic>> slots) async {
    final client = ref.read(supabaseClientProvider);
    await client.from('time_slots').insert(slots);
  }
}

@riverpod
Future<List<TimeSlot>> coachUpcomingSlots(
    Ref ref, String coachId) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('time_slots')
      .select('*, service:services(*)')
      .eq('coach_id', coachId)
      .eq('is_cancelled', false)
      .gte('starts_at', DateTime.now().toIso8601String())
      .order('starts_at');
  return (data as List).map((e) => TimeSlot.fromJson(e)).toList();
}
