import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import '../../../shared/models/models.dart';

class CalendarService {
  CalendarService._();

  static void addBookingToCalendar(Booking booking) {
    final slot = booking.slot;
    final service = booking.service ?? booking.slot?.service;
    if (slot == null) return;

    final event = Event(
      title: service?.title ?? 'Tennis Session',
      description: service?.description ?? '',
      location: booking.coach?.location ?? '',
      startDate: slot.startsAt,
      endDate: slot.endsAt,
    );
    Add2Calendar.addEvent2Cal(event);
  }

  static Future<void> showCalendarPicker(
      BuildContext context, Booking booking) async {
    final slot = booking.slot;
    final service = booking.service ?? booking.slot?.service;
    if (slot == null) return;

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _CalendarPickerSheet(
        booking: booking,
        slot: slot,
        service: service,
      ),
    );
  }
}

class _CalendarPickerSheet extends StatelessWidget {
  const _CalendarPickerSheet({
    required this.booking,
    required this.slot,
    this.service,
  });

  final Booking booking;
  final TimeSlot slot;
  final Service? service;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add to Calendar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Device Calendar'),
              subtitle: const Text('Add to your default calendar'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onTap: () {
                Navigator.pop(context);
                CalendarService.addBookingToCalendar(booking);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
