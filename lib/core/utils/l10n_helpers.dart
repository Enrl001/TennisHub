import '../../l10n/app_localizations.dart';

extension BookingL10n on AppLocalizations {
  String bookingStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return confirmed;
      case 'pending':
        return pending;
      case 'cancelled':
        return cancelled;
      case 'completed':
        return completed;
      default:
        return status;
    }
  }
}
