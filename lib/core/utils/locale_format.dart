import 'package:intl/intl.dart';

/// Locale-aware date/time formatting (defaults to Mongolian patterns when [localeCode] is `mn`).
class LocaleFormat {
  const LocaleFormat(this.localeCode);

  final String localeCode;

  bool get isMn => localeCode == 'mn';

  static const _mnDayAbbr = ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня'];

  static const _mnMonths = [
    '1-р сар',
    '2-р сар',
    '3-р сар',
    '4-р сар',
    '5-р сар',
    '6-р сар',
    '7-р сар',
    '8-р сар',
    '9-р сар',
    '10-р сар',
    '11-р сар',
    '12-р сар',
  ];

  String weekRange(DateTime start, DateTime end) {
    if (isMn) {
      return '${_mnMonths[start.month - 1]}ын ${start.day} - ${end.day}';
    }
    return '${DateFormat('MMMM d', 'en_US').format(start)} - ${DateFormat('d', 'en_US').format(end)}';
  }

  String dayAbbr(DateTime day) {
    if (isMn) return _mnDayAbbr[day.weekday - 1];
    return DateFormat('EEE', 'en_US').format(day).toUpperCase();
  }

  String weekdayShort(DateTime day) {
    if (isMn) return _mnDayAbbr[day.weekday - 1];
    return DateFormat('EEE', 'en_US').format(day);
  }

  String monthShort(DateTime day) {
    if (isMn) return _mnMonths[day.month - 1];
    return DateFormat('MMM', 'en_US').format(day);
  }

  String monthYear(DateTime day) {
    if (isMn) return '${_mnMonths[day.month - 1]} ${day.year}';
    return DateFormat('MMMM yyyy', 'en_US').format(day);
  }

  String time(DateTime dt) {
    if (isMn) return DateFormat('HH:mm').format(dt);
    return DateFormat('h:mm a', 'en_US').format(dt);
  }

  String timeRange(DateTime start, DateTime end) => '${time(start)} - ${time(end)}';

  String displayDate(DateTime dt) {
    if (isMn) {
      return '${dayAbbr(dt)}, ${_mnMonths[dt.month - 1]}ын ${dt.day}, ${dt.year}';
    }
    return DateFormat('EEE, MMM d, yyyy', 'en_US').format(dt);
  }

  String displayDateTime(DateTime dt) {
    if (isMn) {
      return '${_mnMonths[dt.month - 1]}ын ${dt.day}, ${dt.year} · ${time(dt)}';
    }
    return DateFormat('MMM d, yyyy • h:mm a', 'en_US').format(dt);
  }

  String displayDateWithTime(DateTime dt) {
    if (isMn) {
      return '${dayAbbr(dt)}, ${_mnMonths[dt.month - 1]}ын ${dt.day} · ${time(dt)}';
    }
    return DateFormat('EEE, MMM d · h:mm a', 'en_US').format(dt);
  }

  String shortDate(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);
}
