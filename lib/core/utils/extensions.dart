import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import 'locale_format.dart';

extension DateTimeExtensions on DateTime {
  String toDisplayDate([String localeCode = 'mn']) =>
      LocaleFormat(localeCode).displayDate(this);

  String toDisplayDateTime([String localeCode = 'mn']) =>
      LocaleFormat(localeCode).displayDateTime(this);
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}

extension StringExtensions on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String serviceTypeLabel(AppLocalizations l10n) {
    switch (this) {
      case 'private_lesson':
        return l10n.privateLesson;
      case 'group_lesson':
        return l10n.groupLesson;
      case 'community_event':
        return l10n.communityEvent;
      case 'virtual_session':
        return l10n.virtualSession;
      default:
        return capitalize();
    }
  }
}

extension DoubleExtensions on double {
  String toCurrencyString([String currency = 'USD']) =>
      NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(this);
}
