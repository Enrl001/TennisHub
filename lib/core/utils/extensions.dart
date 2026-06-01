import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toDisplayDate() => DateFormat('EEE, MMM d, yyyy').format(this);
  String toDisplayTime() => DateFormat('h:mm a').format(this);
  String toDisplayDateTime() => DateFormat('MMM d, yyyy • h:mm a').format(this);
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}

extension StringExtensions on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String serviceTypeLabel() {
    switch (this) {
      case 'private_lesson':
        return 'Private Lesson';
      case 'group_lesson':
        return 'Group Lesson';
      case 'community_event':
        return 'Community Event';
      case 'virtual_session':
        return 'Virtual Session';
      default:
        return capitalize();
    }
  }
}

extension DoubleExtensions on double {
  String toCurrencyString([String currency = 'USD']) =>
      NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(this);
}
