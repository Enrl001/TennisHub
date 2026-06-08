import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/providers/booking_provider.dart';
import '../../booking/widgets/booking_pay_bar.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final notificationsAsync = ref.watch(notificationsStreamProvider);
    final profile = ref.watch(currentProfileProvider);
    final isCoach = profile?.role == 'coach';
    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      appBar: AppBar(
        backgroundColor: HubStyle.pageBg,
        title: Text(
          l10n.notifications,
          style: const TextStyle(
            color: HubStyle.hubOlive,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        iconTheme: const IconThemeData(color: HubStyle.hubOlive),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(notificationActionsProvider.notifier).markAllAsRead(),
            child: Text(
              l10n.markAllRead,
              style: const TextStyle(fontSize: 12, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => _EmptyNotifications(l10n: l10n),
        data: (notifications) {
          if (notifications.isEmpty) {
            return _EmptyNotifications(l10n: l10n);
          }
          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
            itemBuilder: (_, i) {
              final n = notifications[i];
              final title = locale == 'mn'
                  ? (n.titleMn ?? n.title ?? '')
                  : (n.title ?? '');
              final body = locale == 'mn'
                  ? (n.bodyMn ?? n.body ?? '')
                  : (n.body ?? '');
              final bookingId = n.data?['booking_id']?.toString();
              final showCoachBookingInfo =
                  n.type == 'new_booking' &&
                  isCoach &&
                  bookingId != null;
              final showCustomerPay =
                  !isCoach &&
                  bookingId != null &&
                  (n.type == 'new_booking' || n.type == 'booking_confirmed');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
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
                        fontWeight: n.isRead
                            ? FontWeight.w400
                            : FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (body.isNotEmpty)
                          Text(
                            body,
                            style: const TextStyle(fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (n.createdAt != null)
                          Text(
                            n.createdAt!.toDisplayDateTime(locale),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    tileColor: n.isRead
                        ? null
                        : AppColors.primary.withOpacity(0.03),
                    onTap: () => ref
                        .read(notificationActionsProvider.notifier)
                        .markAsRead(n.id),
                  ),
                  if (showCoachBookingInfo)
                    _CoachBookingInfo(
                      bookingId: bookingId,
                      locale: locale,
                    ),
                  if (showCustomerPay) BookingPayBar(bookingId: bookingId),
                ],
              );
            },
          );
        },
      ),
    );
  }

  IconData _iconForType(String? type) {
    switch (type) {
      case 'booking_confirmed':
        return Icons.check_circle_outline;
      case 'booking_cancelled':
        return Icons.cancel_outlined;
      case 'new_booking':
        return Icons.event_note_outlined;
      case 'payment':
        return Icons.payments_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.notifications_off_outlined,
          size: 64,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.noNotifications,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    ),
  );
}

class _CoachBookingInfo extends ConsumerWidget {
  const _CoachBookingInfo({
    required this.bookingId,
    required this.locale,
  });

  final String bookingId;
  final String locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMn = locale == 'mn';
    final booking = ref.watch(bookingDetailProvider(bookingId)).value;
    if (booking == null) return const SizedBox.shrink();

    final label = switch (booking.status) {
      'confirmed' => isMn ? 'Төлбөр төлөгдсөн · баталгаажсан' : 'Paid · confirmed',
      'pending' => isMn ? 'Төлбөр хүлээгдэж байна' : 'Awaiting customer payment',
      'cancelled' => isMn ? 'Цуцлагдсан' : 'Cancelled',
      _ => booking.status,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(72, 0, 16, 10),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.statusColor(booking.status),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
