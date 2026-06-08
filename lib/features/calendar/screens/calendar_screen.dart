import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/l10n_helpers.dart';
import '../../../core/utils/locale_format.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/models.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/booking_flow.dart';
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

String? _bookingServiceType(Booking booking) =>
    booking.service?.type ?? booking.slot?.service?.type;

String? _slotServiceType(TimeSlot slot, List<Booking> bookings) {
  final fromSlot = slot.service?.type;
  if (fromSlot != null) return fromSlot;
  for (final booking in bookings) {
    if (booking.slotId == slot.id) return _bookingServiceType(booking);
  }
  return null;
}

bool _isGroupLesson(String? type) => type == 'group_lesson';

enum _CalendarViewMode { week, month }

DateTime _weekStartOf(DateTime day) {
  final normalized = DateTime(day.year, day.month, day.day);
  return normalized.subtract(Duration(days: normalized.weekday - 1));
}

bool _isInWeek(DateTime day, DateTime weekAnchor) {
  final start = _weekStartOf(weekAnchor);
  final end = start.add(const Duration(days: 6));
  final d = DateTime(day.year, day.month, day.day);
  return !d.isBefore(start) && !d.isAfter(end);
}

bool _isActiveBooking(Booking booking) =>
    booking.status == 'pending' || booking.status == 'confirmed';

String _slotMergeKey(TimeSlot slot) =>
    '${slot.serviceId}_${slot.startsAt.millisecondsSinceEpoch}';

/// One card per service+start time; booked count sums bookings across duplicate slots.
List<TimeSlot> _mergeSlotsForDisplay(
  List<TimeSlot> slots,
  List<Booking> bookings,
) {
  if (slots.isEmpty) return slots;

  final active = bookings.where(_isActiveBooking);
  final groups = <String, List<TimeSlot>>{};
  for (final slot in slots) {
    groups.putIfAbsent(_slotMergeKey(slot), () => []).add(slot);
  }

  int bookedForSlots(Set<String> slotIds) =>
      active.where((b) => slotIds.contains(b.slotId)).length;

  final merged = groups.values.map((group) {
    final rep = group.first;
    final slotIds = group.map((s) => s.id).toSet();
    final fromBookings = bookedForSlots(slotIds);
    final fromCounts = group.fold<int>(0, (sum, s) => sum + s.bookedCount);
    final booked = fromBookings > fromCounts ? fromBookings : fromCounts;
    return rep.copyWith(bookedCount: booked);
  }).toList();

  merged.sort((a, b) => a.startsAt.compareTo(b.startsAt));
  return merged;
}

String? _bookingMergeKey(Booking booking) {
  final slot = booking.slot;
  if (slot == null) return null;
  return _slotMergeKey(slot);
}

/// Bookings that belong to a group session (by type or same time+service as a group slot).
bool _isGroupSessionBooking(
  Booking booking,
  Set<String> groupMergeKeys,
) {
  if (_isGroupLesson(_bookingServiceType(booking))) return true;
  final key = _bookingMergeKey(booking);
  return key != null && groupMergeKeys.contains(key);
}

List<Booking> _mergeBookingsBySlot(List<Booking> bookings) {
  final merged = <String, Booking>{};
  for (final booking in bookings) {
    final key = _bookingMergeKey(booking) ?? booking.slotId;
    merged.putIfAbsent(key, () => booking);
  }
  final list = merged.values.toList();
  list.sort(
    (a, b) => (a.slot?.startsAt ?? DateTime(0)).compareTo(
      b.slot?.startsAt ?? DateTime(0),
    ),
  );
  return list;
}

/// Timeline rows from actual events (default 08:00–18:00 when empty).
List<int> _timelineHours(List<TimeSlot> slots, List<Booking> bookings) {
  final hours = <int>{};
  for (final slot in slots) {
    hours.add(slot.startsAt.hour);
  }
  for (final booking in bookings) {
    final start = booking.slot?.startsAt;
    if (start != null) hours.add(start.hour);
  }
  if (hours.isEmpty) {
    return List.generate(11, (i) => 8 + i);
  }
  var minH = hours.reduce((a, b) => a < b ? a : b);
  var maxH = hours.reduce((a, b) => a > b ? a : b);
  minH = (minH - 1).clamp(0, 23);
  maxH = (maxH + 1).clamp(0, 23);
  return [for (var h = minH; h <= maxH; h++) h];
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  _CalendarViewMode _viewMode = _CalendarViewMode.week;

  void _goPrevious() {
    setState(() {
      if (_viewMode == _CalendarViewMode.week) {
        _focusedDay = _focusedDay.subtract(const Duration(days: 7));
        if (!_isInWeek(_selectedDay, _focusedDay)) {
          _selectedDay = _weekStartOf(_focusedDay);
        }
      } else {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
        if (_selectedDay.month != _focusedDay.month ||
            _selectedDay.year != _focusedDay.year) {
          _selectedDay = _focusedDay;
        }
      }
    });
  }

  void _goNext() {
    setState(() {
      if (_viewMode == _CalendarViewMode.week) {
        _focusedDay = _focusedDay.add(const Duration(days: 7));
        if (!_isInWeek(_selectedDay, _focusedDay)) {
          _selectedDay = _weekStartOf(_focusedDay);
        }
      } else {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
        if (_selectedDay.month != _focusedDay.month ||
            _selectedDay.year != _focusedDay.year) {
          _selectedDay = _focusedDay;
        }
      }
    });
  }

  void _setViewMode(_CalendarViewMode mode) {
    setState(() {
      _viewMode = mode;
      if (mode == _CalendarViewMode.month) {
        _focusedDay = DateTime(_selectedDay.year, _selectedDay.month, 1);
      } else {
        _focusedDay = _selectedDay;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
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
      // Group slots stay visible (capacity); private booked slots become booking cards.
      final visibleSlots = daySlots.where((slot) {
        final type = _slotServiceType(slot, dayCoachBookings);
        return _isGroupLesson(type) || !bookedSlotIds.contains(slot.id);
      }).toList();
      final groupMergeKeys = visibleSlots
          .where((s) => _isGroupLesson(_slotServiceType(s, dayCoachBookings)))
          .map(_slotMergeKey)
          .toSet();
      final timelineSlots = _mergeSlotsForDisplay(
        visibleSlots,
        dayCoachBookings,
      );
      // Group sessions: one green card with x/max count — no per-customer rows.
      final timelineBookings = _mergeBookingsBySlot(
        dayCoachBookings
            .where((b) => !_isGroupSessionBooking(b, groupMergeKeys))
            .toList(),
      );

      return _WeeklyScheduleView(
        hubTitle: 'COACH HUB',
        notificationsRoute: '/coach-notifications',
        showAddFab: true,
        isCustomerView: false,
        viewMode: _viewMode,
        selectedDay: _selectedDay,
        focusedDay: _focusedDay,
        eventDays: eventDays,
        daySlots: timelineSlots,
        dayBookings: timelineBookings,
        locale: locale,
        onViewModeChanged: _setViewMode,
        onPreviousPeriod: _goPrevious,
        onNextPeriod: _goNext,
        onDaySelected: (selected) => setState(() {
          _selectedDay = selected;
          if (_viewMode == _CalendarViewMode.week) {
            _focusedDay = selected;
          }
        }),
      );
    }

    return _WeeklyScheduleView(
      hubTitle: 'MY CLUB',
      notificationsRoute: '/notifications',
      showAddFab: false,
      isCustomerView: true,
      viewMode: _viewMode,
      selectedDay: _selectedDay,
      focusedDay: _focusedDay,
      eventDays: eventDays,
      daySlots: const [],
      dayBookings: _mergeBookingsBySlot(dayBookings),
      locale: locale,
      onViewModeChanged: _setViewMode,
      onPreviousPeriod: _goPrevious,
      onNextPeriod: _goNext,
      onDaySelected: (selected) => setState(() {
        _selectedDay = selected;
        if (_viewMode == _CalendarViewMode.week) {
          _focusedDay = selected;
        }
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
    required this.viewMode,
    required this.selectedDay,
    required this.focusedDay,
    required this.eventDays,
    required this.daySlots,
    required this.dayBookings,
    required this.locale,
    required this.onViewModeChanged,
    required this.onPreviousPeriod,
    required this.onNextPeriod,
    required this.onDaySelected,
  });

  final String hubTitle;
  final String notificationsRoute;
  final bool showAddFab;
  final bool isCustomerView;
  final _CalendarViewMode viewMode;
  final DateTime selectedDay;
  final DateTime focusedDay;
  final Set<DateTime> eventDays;
  final List<TimeSlot> daySlots;
  final List<Booking> dayBookings;
  final String locale;
  final ValueChanged<_CalendarViewMode> onViewModeChanged;
  final VoidCallback onPreviousPeriod;
  final VoidCallback onNextPeriod;
  final ValueChanged<DateTime> onDaySelected;

  DateTime get _weekStart => _weekStartOf(focusedDay);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fmt = LocaleFormat(locale);
    final weekStart = _weekStart;
    final weekDays = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      appBar: AppBar(
        backgroundColor: HubStyle.pageBg,
        toolbarHeight: 58,
        title: Text(
          hubTitle,
          style: const TextStyle(
            color: HubStyle.hubOlive,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(notificationsRoute),
            icon: const Icon(Icons.notifications_none, color: HubStyle.hubOlive),
          ),
        ],
      ),
      floatingActionButton: showAddFab
          ? FloatingActionButton(
              onPressed: () => context.push('/add-slot'),
              backgroundColor: HubStyle.hubOlive,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            viewMode == _CalendarViewMode.week
                ? l10n.weeklyOverview
                : l10n.monthView,
            style: HubStyle.calendarEyebrow,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: onPreviousPeriod,
                icon: const Icon(Icons.chevron_left, color: HubStyle.hubOlive),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
              Expanded(
                child: Text(
                  viewMode == _CalendarViewMode.week
                      ? fmt.weekRange(weekStart, weekEnd)
                      : fmt.monthYear(focusedDay),
                  style: HubStyle.calendarHeadline,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: onNextPeriod,
                icon: const Icon(Icons.chevron_right, color: HubStyle.hubOlive),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ModePill(
                label: l10n.weekView,
                selected: viewMode == _CalendarViewMode.week,
                onTap: () => onViewModeChanged(_CalendarViewMode.week),
              ),
              const SizedBox(width: 8),
              _ModePill(
                label: l10n.monthView,
                selected: viewMode == _CalendarViewMode.month,
                onTap: () => onViewModeChanged(_CalendarViewMode.month),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (viewMode == _CalendarViewMode.week)
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
                    locale: locale,
                    onTap: () => onDaySelected(day),
                  );
                },
              ),
            )
          else
            _MonthGrid(
              focusedMonth: focusedDay,
              selectedDay: selectedDay,
              eventDays: eventDays,
              locale: locale,
              onDaySelected: onDaySelected,
            ),
          const SizedBox(height: 22),
          _TimelineBoard(
            slots: daySlots,
            bookings: dayBookings,
            locale: locale,
            isCustomerView: isCustomerView,
          ),
        ],
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? HubStyle.hubOlive : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xFFCBD1BA)),
        ),
        child: Text(
          label,
          style: HubStyle.calendarPill.copyWith(
            color: selected ? Colors.white : const Color(0xFF51584D),
          ),
        ),
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.focusedMonth,
    required this.selectedDay,
    required this.eventDays,
    required this.locale,
    required this.onDaySelected,
  });

  final DateTime focusedMonth;
  final DateTime selectedDay;
  final Set<DateTime> eventDays;
  final String locale;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final fmt = LocaleFormat(locale);
    final year = focusedMonth.year;
    final month = focusedMonth.month;
    final firstOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leadingEmpty = firstOfMonth.weekday - 1;
    final totalCells = leadingEmpty + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    final refMonday = DateTime(2024, 1, 1);
    final headerDays = List.generate(
      7,
      (i) => fmt.dayAbbr(refMonday.add(Duration(days: i))),
    );

    return Column(
      children: [
        Row(
          children: headerDays
              .map(
                (label) => Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF6D746B),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        for (var row = 0; row < rowCount; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: List.generate(7, (col) {
                final cellIndex = row * 7 + col;
                if (cellIndex < leadingEmpty || cellIndex >= totalCells) {
                  return const Expanded(child: SizedBox(height: 44));
                }
                final day = cellIndex - leadingEmpty + 1;
                final date = DateTime(year, month, day);
                final selected = _isSameCalendarDay(date, selectedDay);
                final hasEvent = eventDays.contains(
                  DateTime(date.year, date.month, date.day),
                );
                return Expanded(
                  child: _MonthDayCell(
                    day: day,
                    selected: selected,
                    hasEvent: hasEvent,
                    onTap: () => onDaySelected(date),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _MonthDayCell extends StatelessWidget {
  const _MonthDayCell({
    required this.day,
    required this.selected,
    required this.hasEvent,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final bool hasEvent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: selected ? HubStyle.hubOlive : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.tennisGreen : const Color(0xFFE4E6DC),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF717171),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (hasEvent)
              Container(
                width: 4,
                height: 4,
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

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.day,
    required this.selected,
    required this.hasEvent,
    required this.locale,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final bool hasEvent;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fmt = LocaleFormat(locale);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        width: 58,
        decoration: BoxDecoration(
          color: selected ? HubStyle.hubOlive : HubStyle.cardBorder,
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
              fmt.dayAbbr(day),
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
    required this.locale,
    this.isCustomerView = false,
  });

  final List<TimeSlot> slots;
  final List<Booking> bookings;
  final String locale;
  final bool isCustomerView;

  @override
  Widget build(BuildContext context) {
    final hasEvents = slots.isNotEmpty || bookings.isNotEmpty;
    if (!hasEvents) return _EmptyDay(locale: locale);

    final hours = _timelineHours(slots, bookings);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE2D2)),
      ),
      child: Column(
        children: List.generate(hours.length, (index) {
          final hour = hours[index];
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
            locale: locale,
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
    required this.locale,
    required this.isCustomerView,
    required this.showTopBorder,
  });

  final int hour;
  final List<TimeSlot> slots;
  final List<Booking> bookings;
  final String locale;
  final bool isCustomerView;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      ...slots.map((slot) => _TimelineSlotCard(slot: slot, locale: locale)),
      ...bookings.map(
        (booking) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TimelineBookingCard(
              booking: booking,
              locale: locale,
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
  const _TimelineSlotCard({required this.slot, required this.locale});

  final TimeSlot slot;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fmt = LocaleFormat(locale);
    final service = slot.service;
    final isGroup = _isGroupLesson(service?.type);
    final title = service == null
        ? l10n.openSlot
        : (fmt.isMn ? (service.titleMn ?? service.title) : service.title);
    final max = service?.maxParticipants ?? 1;
    final isFull = slot.bookedCount >= max;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => openSessionSlot(context, slot.id),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isGroup ? AppColors.tennisGreen : const Color(0xFFF0F2F4),
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(
                color: isGroup ? HubStyle.hubOlive : HubStyle.slateMuted,
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
                      style: HubStyle.timelineTitle,
                    ),
                  ),
                  _StatusTag(
                    label: isFull && isGroup
                        ? l10n.slotFull
                        : l10n.statusOpen,
                    color: HubStyle.hubOlive,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                fmt.timeRange(slot.startsAt, slot.endsAt),
                style: HubStyle.timelineMeta,
              ),
              const SizedBox(height: 4),
              Text(
                '${slot.bookedCount}/$max ${l10n.playersBooked}',
                style: HubStyle.timelineMeta,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineBookingCard extends StatelessWidget {
  const _TimelineBookingCard({
    required this.booking,
    required this.locale,
    this.isCustomerView = false,
  });

  final Booking booking;
  final String locale;
  final bool isCustomerView;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fmt = LocaleFormat(locale);
    final slot = booking.slot;
    final service = booking.service ?? slot?.service;
    final title = service == null
        ? l10n.session
        : (fmt.isMn ? (service.titleMn ?? service.title) : service.title);
    final subtitle = isCustomerView
        ? (booking.coach?.profile?.fullName ?? l10n.coach)
        : (booking.customer?.fullName ?? l10n.customer);
    final statusColor = AppColors.statusColor(booking.status);
    final timeLabel = slot != null
        ? fmt.timeRange(slot.startsAt, slot.endsAt)
        : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => openSession(context, booking.id),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F2F4),
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              left: BorderSide(color: HubStyle.slateMuted, width: 3),
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
                child: const Icon(Icons.person_outline, color: HubStyle.slateMuted),
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
                      style: HubStyle.timelineTitle,
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: HubStyle.slateMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (timeLabel != null) ...[
                      const SizedBox(height: 4),
                      Text(timeLabel, style: HubStyle.timelineMeta),
                    ],
                  ],
                ),
              ),
              _StatusTag(label: l10n.bookingStatus(booking.status), color: statusColor),
            ],
          ),
        ),
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
        style: HubStyle.timelineBadge.copyWith(color: color),
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.locale});
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
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
            l10n.nothingScheduled,
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
}
