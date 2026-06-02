import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../models/models.dart';

class SlotPicker extends StatefulWidget {
  const SlotPicker({
    super.key,
    required this.slots,
    required this.maxParticipants,
    this.onSlotSelected,
  });

  final List<TimeSlot> slots;
  final int maxParticipants;
  final ValueChanged<TimeSlot?>? onSlotSelected;

  @override
  State<SlotPicker> createState() => _SlotPickerState();
}

class _SlotPickerState extends State<SlotPicker> {
  DateTime? _selectedDate;
  TimeSlot? _selectedSlot;

  List<DateTime> get _dates {
    final seen = <String>{};
    final result = <DateTime>[];
    for (final s in widget.slots) {
      final key = '${s.startsAt.year}-${s.startsAt.month}-${s.startsAt.day}';
      if (seen.add(key)) result.add(s.startsAt);
    }
    return result;
  }

  List<TimeSlot> _slotsForDate(DateTime date) =>
      widget.slots.where((s) => _isSameDay(s.startsAt, date)).toList();

  @override
  void initState() {
    super.initState();
    if (widget.slots.isNotEmpty) {
      _selectedDate = widget.slots.first.startsAt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dates = _dates;
    final slotsForDay = _selectedDate != null
        ? _slotsForDate(_selectedDate!)
        : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date strip
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: dates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final d = dates[i];
              final selected =
                  _selectedDate != null && _isSameDay(_selectedDate!, d);
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedDate = d;
                  _selectedSlot = null;
                  widget.onSlotSelected?.call(null);
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.cardBorder,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weekday(d),
                        style: TextStyle(
                          fontSize: 11,
                          color: selected ? Colors.white70 : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${d.day}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        _month(d),
                        style: TextStyle(
                          fontSize: 11,
                          color: selected ? Colors.white70 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Time grid
        if (slotsForDay.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slotsForDay.map((slot) {
                final isFull = slot.bookedCount >= widget.maxParticipants;
                final isSelected = _selectedSlot?.id == slot.id;
                final spotsLeft = (widget.maxParticipants - slot.bookedCount)
                    .toInt();

                return GestureDetector(
                  onTap: isFull
                      ? null
                      : () => setState(() {
                          _selectedSlot = slot;
                          widget.onSlotSelected?.call(slot);
                        }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isFull
                          ? Colors.grey.shade100
                          : isSelected
                          ? AppColors.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFull
                            ? Colors.grey.shade300
                            : isSelected
                            ? AppColors.primary
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _timeFormat.format(slot.startsAt),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isFull
                                ? Colors.grey
                                : isSelected
                                ? Colors.white
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isFull ? l10n.slotFull : l10n.slotsLeft(spotsLeft),
                          style: TextStyle(
                            fontSize: 11,
                            color: isFull
                                ? Colors.grey
                                : isSelected
                                ? Colors.white70
                                : spotsLeft <= 2
                                ? Colors.orange
                                : AppColors.groupLesson,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                l10n.noBookingsToday,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  String _weekday(DateTime d) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d.weekday - 1];
  String _month(DateTime d) => [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][d.month - 1];
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  static final _timeFormat = DateFormat('h:mm a');
}
