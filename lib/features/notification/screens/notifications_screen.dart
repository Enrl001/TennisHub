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
    final handledNotificationIds = ref.watch(
      handledBookingNotificationsProvider,
    );

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
              final isBookingRequest =
                  n.type == 'new_booking' &&
                  isCoach &&
                  bookingId != null &&
                  !handledNotificationIds.contains(n.id);
              final showCustomerPay =
                  !isCoach &&
                  n.type == 'booking_confirmed' &&
                  bookingId != null;

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
                            n.createdAt!.toDisplayDateTime(),
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
                  // Approve / Reject actions for coach on new booking requests
                  if (isBookingRequest)
                    _BookingActions(
                      bookingId: bookingId,
                      notificationId: n.id,
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

class _BookingActions extends ConsumerStatefulWidget {
  const _BookingActions({
    required this.bookingId,
    required this.notificationId,
    required this.locale,
  });
  final String bookingId;
  final String notificationId;
  final String locale;

  @override
  ConsumerState<_BookingActions> createState() => _BookingActionsState();
}

class _BookingActionsState extends ConsumerState<_BookingActions> {
  bool _loading = false;
  String? _done; // 'approved' | 'rejected'

  String _errorMessage(Object error) {
    final isMn = widget.locale == 'mn';
    final message = error.toString();
    if (message.contains('Not enough available places')) {
      return isMn
          ? 'Энэ цагийн сул орон зай дууссан байна.'
          : 'This time slot is already full.';
    }
    return isMn ? 'Үйлдэл амжилтгүй боллоо.' : 'Action failed.';
  }

  Future<void> _approve() async {
    setState(() => _loading = true);
    final bookingActions = ref.read(bookingProvider.notifier);
    final notificationActions = ref.read(notificationActionsProvider.notifier);
    try {
      await bookingActions.approveBooking(widget.bookingId);
      if (!mounted) return;
      await notificationActions.markAsRead(widget.notificationId);
      if (!mounted) return;
      ref
          .read(handledBookingNotificationsProvider.notifier)
          .markHandled(widget.notificationId);
      setState(() => _done = 'approved');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage(e)),
            backgroundColor: AppColors.statusCancelled,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _reject() async {
    setState(() => _loading = true);
    final bookingActions = ref.read(bookingProvider.notifier);
    final notificationActions = ref.read(notificationActionsProvider.notifier);
    try {
      await bookingActions.rejectBooking(widget.bookingId);
      if (!mounted) return;
      await notificationActions.markAsRead(widget.notificationId);
      if (!mounted) return;
      ref
          .read(handledBookingNotificationsProvider.notifier)
          .markHandled(widget.notificationId);
      setState(() => _done = 'rejected');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage(e)),
            backgroundColor: AppColors.statusCancelled,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMn = widget.locale == 'mn';
    final bookingAsync = ref.watch(bookingDetailProvider(widget.bookingId));

    if (_done == 'approved') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(72, 0, 16, 10),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 16),
            const SizedBox(width: 6),
            Text(
              isMn ? 'Баталгаажуулсан' : 'Confirmed',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    if (_done == 'rejected') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(72, 0, 16, 10),
        child: Row(
          children: [
            Icon(Icons.cancel, color: Colors.grey.shade400, size: 16),
            const SizedBox(width: 6),
            Text(
              isMn ? 'Цуцалсан' : 'Rejected',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ],
        ),
      );
    }

    final booking = bookingAsync.value;
    if (bookingAsync.isLoading && booking == null) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(72, 0, 16, 10),
        child: SizedBox(
          height: 24,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );
    }
    if (booking == null || booking.status != 'pending') {
      final status = booking?.status ?? '';
      if (status.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.fromLTRB(72, 0, 16, 10),
        child: Text(
          status == 'confirmed'
              ? (isMn ? 'Баталгаажсан' : 'Confirmed')
              : status,
          style: TextStyle(
            color: AppColors.statusColor(status),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(72, 0, 16, 10),
      child: _loading
          ? const SizedBox(
              height: 28,
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.statusCancelled,
                      side: const BorderSide(color: AppColors.statusCancelled),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      isMn ? 'Татгалзах' : 'Decline',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _approve,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      isMn ? 'Зөвшөөрөх' : 'Approve',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
