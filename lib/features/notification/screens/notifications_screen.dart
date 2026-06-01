import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final notificationsAsync = ref.watch(notificationsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationActionsProvider.notifier).markAllAsRead(),
            child: Text(l10n.markAllRead,
                style: const TextStyle(fontSize: 12, color: AppColors.primary)),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text(e.toString())),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.noNotifications,
                      style: const TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }
          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
            itemBuilder: (_, i) {
              final n = notifications[i];
              final title = locale == 'mn' ? (n.titleMn ?? n.title ?? '') : (n.title ?? '');
              final body = locale == 'mn' ? (n.bodyMn ?? n.body ?? '') : (n.body ?? '');
              return ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: n.isRead
                        ? Colors.grey.shade100
                        : AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _iconForType(n.type),
                    color: n.isRead ? Colors.grey : AppColors.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: n.isRead ? FontWeight.w400 : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (body.isNotEmpty)
                      Text(body, style: const TextStyle(fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                    if (n.createdAt != null)
                      Text(
                        n.createdAt!.toDisplayDateTime(),
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                  ],
                ),
                tileColor: n.isRead ? null : AppColors.primary.withOpacity(0.03),
                onTap: () => ref
                    .read(notificationActionsProvider.notifier)
                    .markAsRead(n.id),
              );
            },
          );
        },
      ),
    );
  }

  IconData _iconForType(String? type) {
    switch (type) {
      case 'booking_confirmed': return Icons.check_circle_outline;
      case 'booking_cancelled': return Icons.cancel_outlined;
      case 'new_booking': return Icons.event_note_outlined;
      case 'payment': return Icons.payments_outlined;
      default: return Icons.notifications_outlined;
    }
  }
}
