import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/models/models.dart';

final _uuidPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  caseSensitive: false,
);

bool isValidUuid(String? value) {
  if (value == null) return false;
  final v = value.trim();
  if (_uuidPattern.hasMatch(v)) return true;
  return RegExp(r'^[0-9a-f]{32}$', caseSensitive: false).hasMatch(v);
}

/// Coerces API values (string, int, nested map) into a plain id string.
String coerceEntityId(dynamic value) {
  if (value == null) return '';
  if (value is String) return value.trim();
  if (value is Map) {
    final nested = value['id'] ?? value['uuid'];
    if (nested != null) return coerceEntityId(nested);
  }
  return value.toString().trim();
}

/// Returns a dashed lowercase UUID when [raw] is a valid UUID form.
String? tryResolveUuid(String? raw) {
  if (raw == null) return null;
  final v = raw.trim();
  if (v.isEmpty) return null;
  if (!isValidUuid(v)) return null;
  return normalizeUuid(v);
}

/// Normalizes UUIDs for Supabase (adds dashes when missing).
String normalizeUuid(String id) {
  final v = id.trim();
  if (_uuidPattern.hasMatch(v)) return v.toLowerCase();
  if (RegExp(r'^[0-9a-f]{32}$', caseSensitive: false).hasMatch(v)) {
    final h = v.toLowerCase();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-'
        '${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }
  return v;
}

bool bookingHasPrice(Booking booking) => (booking.amountPaid ?? 0) > 0;

/// Redirect legacy `/booking/<uuid-with-dashes>` URLs to query form.
String? legacyBookingPathRedirect(String path) {
  const prefix = '/booking/';
  if (!path.startsWith(prefix) || path.length <= prefix.length) return null;
  final serviceId = path.substring(prefix.length);
  if (serviceId.isEmpty || !serviceId.contains('-')) return null;
  return '/booking?serviceId=${Uri.encodeComponent(serviceId)}';
}

/// Redirect legacy `/coach/<uuid-with-dashes>` URLs to query form.
String? legacyCoachPathRedirect(String path) {
  const prefix = '/coach/';
  if (!path.startsWith(prefix) || path.length <= prefix.length) return null;
  final coachId = path.substring(prefix.length);
  if (coachId.isEmpty || !coachId.contains('-')) return null;
  return '/coach?coachId=${Uri.encodeComponent(coachId)}';
}

void openCoachDetail(BuildContext context, String coachId) {
  context.pushNamed('coachDetail', queryParameters: {'coachId': coachId});
}

void openBooking(BuildContext context, String serviceId) {
  context.pushNamed('booking', queryParameters: {'serviceId': serviceId});
}

void openPayment(
  BuildContext context, {
  required String bookingId,
  required double amount,
  required String currency,
  bool autoPay = true,
}) {
  context.pushNamed(
    'payment',
    queryParameters: {
      'bookingId': bookingId,
      'amount': amount.round().toString(),
      'currency': currency,
      if (autoPay) 'autoPay': 'true',
    },
  );
}

void goPayment(
  BuildContext context, {
  required String bookingId,
  required double amount,
  required String currency,
  bool autoPay = true,
}) {
  context.goNamed(
    'payment',
    queryParameters: {
      'bookingId': bookingId,
      'amount': amount.round().toString(),
      'currency': currency,
      if (autoPay) 'autoPay': 'true',
    },
  );
}

void goBookingSuccess(BuildContext context, String bookingId) {
  context.goNamed('bookingSuccess', queryParameters: {'bookingId': bookingId});
}

void openSession(BuildContext context, String bookingId) {
  context.pushNamed(
    'session',
    queryParameters: {'bookingId': bookingId},
  );
}

void openSessionSlot(BuildContext context, String slotId) {
  context.pushNamed(
    'session',
    queryParameters: {'slotId': slotId},
  );
}

/// After creating a booking, go to Smartpay payment or success if free.
void navigateAfterBooking(
  BuildContext context, {
  required Booking booking,
  required Service service,
}) {
  final amount = booking.amountPaid ?? service.priceAmount ?? 0;
  if (amount <= 0) {
    goBookingSuccess(context, booking.id);
    return;
  }
  goPayment(
    context,
    bookingId: booking.id,
    amount: amount,
    currency: booking.currency ?? service.currency ?? 'MNT',
    autoPay: true,
  );
}
