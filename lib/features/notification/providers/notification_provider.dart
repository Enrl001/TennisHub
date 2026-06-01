import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/supabase_providers.dart';

part 'notification_provider.g.dart';

@riverpod
Stream<List<AppNotification>> notificationsStream(
    Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) return const Stream.empty();

  return client
      .from('notifications')
      .stream(primaryKey: ['id'])
      .eq('user_id', user.id)
      .order('created_at', ascending: false)
      .map((list) =>
          list.map((e) => AppNotification.fromJson(e)).toList());
}

@riverpod
int unreadCount(Ref ref) {
  final notifications =
      ref.watch(notificationsStreamProvider).value ?? [];
  return notifications.where((n) => !n.isRead).length;
}

@riverpod
class NotificationActions extends _$NotificationActions {
  @override
  void build() {}

  Future<void> markAsRead(String notificationId) async {
    final client = ref.read(supabaseClientProvider);
    await client
        .from('notifications')
        .update({'is_read': true}).eq('id', notificationId);
  }

  Future<void> markAllAsRead() async {
    final client = ref.read(supabaseClientProvider);
    final user = client.auth.currentUser;
    if (user == null) return;
    await client
        .from('notifications')
        .update({'is_read': true}).eq('user_id', user.id);
  }
}
