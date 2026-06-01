import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/booking_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/providers/booking_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentProfileProvider);
    final isCoach = profile?.role == 'coach';

    final bookingsAsync = isCoach
        ? ref.watch(coachBookingsProvider)
        : ref.watch(myBookingsProvider);

    final bookings = bookingsAsync.value ?? [];

    // Build event map: date -> list of bookings
    final eventMap = <DateTime, List<Booking>>{};
    for (final b in bookings) {
      final date = b.slot?.startsAt;
      if (date == null) continue;
      final key = DateTime(date.year, date.month, date.day);
      eventMap.putIfAbsent(key, () => []).add(b);
    }

    final selectedKey = DateTime(
        _selectedDay.year, _selectedDay.month, _selectedDay.day);
    final selectedBookings = eventMap[selectedKey] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(isCoach ? l10n.mySchedule : l10n.calendar)),
      body: Column(
        children: [
          TableCalendar<Booking>(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
            eventLoader: (day) {
              final key = DateTime(day.year, day.month, day.day);
              return eventMap[key] ?? [];
            },
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            onPageChanged: (focused) => setState(() => _focusedDay = focused),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(formatButtonVisible: false),
          ),
          const Divider(height: 1),
          Expanded(
            child: bookingsAsync.isLoading
                ? const Center(child: CircularProgressIndicator())
                : selectedBookings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.event_available_outlined,
                                size: 48, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(l10n.noBookingsToday,
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: selectedBookings.length,
                        itemBuilder: (_, i) => BookingCard(
                          booking: selectedBookings[i],
                          isCoach: isCoach,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
