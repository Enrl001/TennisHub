import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/models.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/providers/booking_provider.dart';
import '../../booking/widgets/booking_pay_bar.dart';
import '../../coach/providers/coach_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

bool _isSameCalendarDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final isMn = locale == 'mn';
    final profile = ref.watch(currentProfileProvider);
    final isCoach = profile?.role == 'coach';

    // Coach sees their time slots + customer bookings; customer sees their own bookings
    final coachSlotsAsync = isCoach ? ref.watch(myCoachSlotsProvider) : null;
    final coachBookingsCalAsync = isCoach
        ? ref.watch(coachCalendarBookingsProvider)
        : null;
    final bookingsAsync = isCoach ? null : ref.watch(myBookingsProvider);

    // Build event map
    final eventDays = <DateTime>{};
    final List<TimeSlot> coachSlots = coachSlotsAsync?.value ?? [];
    final List<Booking> coachCalBookings = coachBookingsCalAsync?.value ?? [];
    final List<Booking> customerBookings = bookingsAsync?.value ?? [];

    for (final s in coachSlots) {
      final d = s.startsAt;
      eventDays.add(DateTime(d.year, d.month, d.day));
    }
    for (final b in coachCalBookings) {
      final d = b.slot?.startsAt;
      if (d != null) eventDays.add(DateTime(d.year, d.month, d.day));
    }
    for (final b in customerBookings) {
      final d = b.slot?.startsAt;
      if (d != null) eventDays.add(DateTime(d.year, d.month, d.day));
    }

    final List<TimeSlot> daySlots = coachSlots.where((s) {
      final d = s.startsAt;
      return d.year == _selectedDay.year &&
          d.month == _selectedDay.month &&
          d.day == _selectedDay.day;
    }).toList()..sort((a, b) => a.startsAt.compareTo(b.startsAt));

    final List<Booking> dayCoachBookings =
        coachCalBookings.where((b) {
          final d = b.slot?.startsAt;
          return d != null &&
              d.year == _selectedDay.year &&
              d.month == _selectedDay.month &&
              d.day == _selectedDay.day;
        }).toList()..sort(
          (a, b) => (a.slot?.startsAt ?? DateTime(0)).compareTo(
            b.slot?.startsAt ?? DateTime(0),
          ),
        );

    final List<Booking> dayBookings =
        customerBookings.where((b) {
          final d = b.slot?.startsAt;
          return d != null &&
              d.year == _selectedDay.year &&
              d.month == _selectedDay.month &&
              d.day == _selectedDay.day;
        }).toList()..sort(
          (a, b) => (a.slot?.startsAt ?? DateTime(0)).compareTo(
            b.slot?.startsAt ?? DateTime(0),
          ),
        );

    if (isCoach) {
      final bookedSlotIds = dayCoachBookings.map((b) => b.slotId).toSet();
      final timelineSlots = daySlots.where((slot) {
        final type = slot.service?.type;
        return type == 'group_lesson' || !bookedSlotIds.contains(slot.id);
      }).toList();
      final timelineBookings = dayCoachBookings.where((booking) {
        final type = (booking.service ?? booking.slot?.service)?.type;
        return type != 'group_lesson';
      }).toList();

      return _WeeklyScheduleView(
        hubTitle: 'COACH HUB',
        notificationsRoute: '/coach-notifications',
        showAddFab: true,
        isCustomerView: false,
        selectedDay: _selectedDay,
        focusedDay: _focusedDay,
        eventDays: eventDays,
        daySlots: timelineSlots,
        dayBookings: timelineBookings,
        isMn: isMn,
        onDaySelected: (selected) => setState(() {
          _selectedDay = selected;
          _focusedDay = selected;
        }),
      );
    }

    return _WeeklyScheduleView(
      hubTitle: 'MY CLUB',
      notificationsRoute: '/notifications',
      showAddFab: false,
      isCustomerView: true,
      selectedDay: _selectedDay,
      focusedDay: _focusedDay,
      eventDays: eventDays,
      daySlots: const [],
      dayBookings: dayBookings,
      isMn: isMn,
      onDaySelected: (selected) => setState(() {
        _selectedDay = selected;
        _focusedDay = selected;
      }),
    );
  }
}

class _WeeklyScheduleView extends StatelessWidget {
  const _WeeklyScheduleView({
    required this.hubTitle,
    required this.notificationsRoute,
    required this.showAddFab,
    required this.isCustomerView,
    required this.selectedDay,
    required this.focusedDay,
    required this.eventDays,
    required this.daySlots,
    required this.dayBookings,
    required this.isMn,
    required this.onDaySelected,
  });

  static const _pageBg = Color(0xFFF5F6F8);
  static const _hubOlive = Color(0xFF526300);

  final String hubTitle;
  final String notificationsRoute;
  final bool showAddFab;
  final bool isCustomerView;
  final DateTime selectedDay;
  final DateTime focusedDay;
  final Set<DateTime> eventDays;
  final List<TimeSlot> daySlots;
  final List<Booking> dayBookings;
  final bool isMn;
  final ValueChanged<DateTime> onDaySelected;

  DateTime get _weekStart {
    final normalized = DateTime(
      focusedDay.year,
      focusedDay.month,
      focusedDay.day,
    );
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final weekStart = _weekStart;
    final weekDays = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: _pageBg,
        toolbarHeight: 58,
        title: Text(
          hubTitle,
          style: const TextStyle(
            color: _hubOlive,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(notificationsRoute),
            icon: const Icon(Icons.notifications_none, color: _hubOlive),
          ),
        ],
      ),
      floatingActionButton: showAddFab
          ? FloatingActionButton(
              onPressed: () => context.push('/add-slot'),
              backgroundColor: _hubOlive,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            isMn ? 'ДОЛОО ХОНОГИЙН ТОЙМ' : 'WEEKLY OVERVIEW',
            style: const TextStyle(
              color: Color(0xFF647086),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${DateFormat('MMMM d').format(weekStart)} - ${DateFormat('d').format(weekEnd)}',
            style: const TextStyle(
              color: Color(0xFF181A20),
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ModePill(label: isMn ? '7 хоног' : 'Week', selected: true),
              const SizedBox(width: 8),
              _ModePill(label: isMn ? 'Сар' : 'Month', selected: false),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 74,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: weekDays.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final day = weekDays[index];
                final selected = _isSameCalendarDay(day, selectedDay);
                final key = DateTime(day.year, day.month, day.day);
                final hasEvent = eventDays.contains(key);
                return _DayPill(
                  day: day,
                  selected: selected,
                  hasEvent: hasEvent,
                  onTap: () => onDaySelected(day),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          _TimelineBoard(
            slots: daySlots,
            bookings: dayBookings,
            isMn: isMn,
            isCustomerView: isCustomerView,
          ),
        ],
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF526300) : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFCBD1BA)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF51584D),
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.day,
    required this.selected,
    required this.hasEvent,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final bool hasEvent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        width: 58,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF526300) : const Color(0xFFF0F1F2),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected ? AppColors.tennisGreen : const Color(0xFFD8DDCD),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(day).toUpperCase(),
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF6D746B),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '${day.day}',
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF717171),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (hasEvent)
              Container(
                width: 5,
                height: 5,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: selected ? AppColors.tennisGreen : AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineBoard extends StatelessWidget {
  const _TimelineBoard({
    required this.slots,
    required this.bookings,
    required this.isMn,
    this.isCustomerView = false,
  });

  final List<TimeSlot> slots;
  final List<Booking> bookings;
  final bool isMn;
  final bool isCustomerView;

  @override
  Widget build(BuildContext context) {
    final hasEvents = slots.isNotEmpty || bookings.isNotEmpty;
    if (!hasEvents) return _EmptyDay(isMn: isMn);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE2D2)),
      ),
      child: Column(
        children: List.generate(11, (index) {
          final hour = 8 + index;
          final hourSlots = slots
              .where((s) => s.startsAt.hour == hour)
              .toList();
          final hourBookings = bookings
              .where((b) => b.slot != null && b.slot!.startsAt.hour == hour)
              .toList();
          return _TimelineHourRow(
            hour: hour,
            slots: hourSlots,
            bookings: hourBookings,
            isMn: isMn,
            isCustomerView: isCustomerView,
            showTopBorder: index > 0,
          );
        }),
      ),
    );
  }
}

class _TimelineHourRow extends StatelessWidget {
  const _TimelineHourRow({
    required this.hour,
    required this.slots,
    required this.bookings,
    required this.isMn,
    required this.isCustomerView,
    required this.showTopBorder,
  });

  final int hour;
  final List<TimeSlot> slots;
  final List<Booking> bookings;
  final bool isMn;
  final bool isCustomerView;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      ...slots.map((slot) => _TimelineSlotCard(slot: slot, isMn: isMn)),
      ...bookings.map(
        (booking) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TimelineBookingCard(
              booking: booking,
              isMn: isMn,
              isCustomerView: isCustomerView,
            ),
            if (isCustomerView) BookingPayBar(bookingId: booking.id),
          ],
        ),
      ),
    ];

    return Container(
      constraints: const BoxConstraints(minHeight: 86),
      decoration: BoxDecoration(
        border: showTopBorder
            ? const Border(top: BorderSide(color: Color(0xFFE7E9E1)))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                '${hour.toString().padLeft(2, '0')}:00',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF3F453E),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
              child: items.isEmpty
                  ? const SizedBox(height: 48)
                  : Column(children: items),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineSlotCard extends StatelessWidget {
  const _TimelineSlotCard({required this.slot, required this.isMn});

  final TimeSlot slot;
  final bool isMn;

  @override
  Widget build(BuildContext context) {
    final service = slot.service;
    final isGroup = service?.type == 'group_lesson';
    final title = service == null
        ? (isMn ? 'Нээлттэй цаг' : 'Open Slot')
        : (isMn ? (service.titleMn ?? service.title) : service.title);
    final max = service?.maxParticipants ?? 1;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isGroup ? AppColors.tennisGreen : const Color(0xFFF0F2F4),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: isGroup ? const Color(0xFF526300) : const Color(0xFF53657E),
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF182015),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              _StatusTag(
                label: isMn ? 'НЭЭЛТТЭЙ' : 'OPEN',
                color: const Color(0xFF526300),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${DateFormat('h:mm a').format(slot.startsAt)} - ${DateFormat('h:mm a').format(slot.endsAt)}',
            style: const TextStyle(
              color: Color(0xFF526300),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${slot.bookedCount}/$max ${isMn ? 'захиалсан' : 'players'}',
            style: const TextStyle(
              color: Color(0xFF526300),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineBookingCard extends StatelessWidget {
  const _TimelineBookingCard({
    required this.booking,
    required this.isMn,
    this.isCustomerView = false,
  });

  final Booking booking;
  final bool isMn;
  final bool isCustomerView;

  @override
  Widget build(BuildContext context) {
    final slot = booking.slot;
    final service = booking.service ?? slot?.service;
    final title = service == null
        ? (isMn ? 'Хичээл' : 'Session')
        : (isMn ? (service.titleMn ?? service.title) : service.title);
    final subtitle = isCustomerView
        ? (booking.coach?.profile?.fullName ?? (isMn ? 'Тренер' : 'Coach'))
        : (booking.customer?.fullName ?? (isMn ? 'Хэрэглэгч' : 'Customer'));
    final statusColor = AppColors.statusColor(booking.status);
    final timeLabel = slot != null
        ? '${DateFormat('h:mm a').format(slot.startsAt)} - ${DateFormat('h:mm a').format(slot.endsAt)}'
        : null;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F4),
        borderRadius: BorderRadius.circular(10),
        border: const Border(
          left: BorderSide(color: Color(0xFF53657E), width: 3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFDDE6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, color: Color(0xFF53657E)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF182015),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF53657E),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (timeLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    timeLabel,
                    style: const TextStyle(
                      color: Color(0xFF526300),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _StatusTag(label: booking.status.toUpperCase(), color: statusColor),
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.isMn});
  final bool isMn;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.event_available_outlined,
          size: 56,
          color: Colors.grey.shade300,
        ),
        const SizedBox(height: 12),
        Text(
          isMn ? 'Тэмдэглэгдсэн цаг байхгүй' : 'Nothing scheduled',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
