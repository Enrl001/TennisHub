import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/supabase_providers.dart';

part 'notification_provider.g.dart';

Map<String, dynamic> _fixNotificationJson(Map<String, dynamic> json) {
  final m = Map<String, dynamic>.from(json);
  for (final key in [
    'id',
    'user_id',
    'type',
    'title',
    'title_mn',
    'body',
    'body_mn',
    'created_at',
  ]) {
    if (m[key] != null) m[key] = m[key].toString();
  }

  final data = m['data'];
  if (data is Map) {
    m['data'] = data.map((key, value) => MapEntry(key.toString(), value));
  }

  final isRead = m['is_read'];
  if (isRead is int) m['is_read'] = isRead != 0;
  return m;
}

@riverpod
Stream<List<AppNotification>> notificationsStream(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) return const Stream.empty();

  return client
      .from('notifications')
      .stream(primaryKey: ['id'])
      .eq('user_id', user.id)
      .order('created_at', ascending: false)
      .map(
        (list) => list
            .map(
              (e) => AppNotification.fromJson(
                _fixNotificationJson(Map<String, dynamic>.from(e)),
              ),
            )
            .toList(),
      );
}

@riverpod
int unreadCount(Ref ref) {
  final notifications = ref.watch(notificationsStreamProvider).value ?? [];
  return notifications.where((n) => !n.isRead).length;
}

@riverpod
class HandledBookingNotifications extends _$HandledBookingNotifications {
  @override
  Set<String> build() => <String>{};

  void markHandled(String notificationId) {
    state = {...state, notificationId};
  }
}

@riverpod
class NotificationActions extends _$NotificationActions {
  @override
  void build() {}

  Future<void> markAsRead(String notificationId) async {
    final client = ref.read(supabaseClientProvider);
    await client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  Future<void> markAllAsRead() async {
    final client = ref.read(supabaseClientProvider);
    final user = client.auth.currentUser;
    if (user == null) return;
    await client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', user.id);
  }
}
