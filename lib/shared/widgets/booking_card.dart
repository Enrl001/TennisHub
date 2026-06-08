import 'package:flutter/material.dart';
import '../../features/booking/booking_flow.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/l10n_helpers.dart';
import '../../core/utils/locale_format.dart';
import '../../l10n/app_localizations.dart';
import '../extensions/local_ext.dart';
import '../models/models.dart';
import 'service_chip.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    this.isCoach = false,
    this.locale = 'mn',
    this.onTap,
  });

  final Booking booking;
  final bool isCoach;
  final String locale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final slot = booking.slot;
    final service = booking.service ?? booking.slot?.service;
    final l10n = AppLocalizations.of(context);
    final fmt = LocaleFormat(locale);
    final color = AppColors.statusColor(booking.status);

    final title = service != null
        ? service.localTitle(locale)
        : l10n.session;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: HubStyle.cardBorder),
      ),
      child: InkWell(
        onTap: onTap ?? () => openSession(context, booking.id),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (service != null)
                    ServiceChip(type: service.type, small: true),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.bookingStatus(booking.status),
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (isCoach && booking.customer != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      booking.customer!.fullName ?? l10n.customer,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
              if (!isCoach && booking.coach?.profile != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.sports_tennis,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      booking.coach!.profile!.fullName ?? l10n.coach,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
              if (slot != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      fmt.displayDate(slot.startsAt),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.access_time_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      fmt.time(slot.startsAt),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
              if (booking.amountPaid != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      booking.amountPaid!.toCurrencyString(
                        booking.currency ?? 'USD',
                      ),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
