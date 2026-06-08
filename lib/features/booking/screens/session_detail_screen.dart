import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/l10n_helpers.dart';
import '../../../core/utils/locale_format.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/extensions/local_ext.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/hub_ui.dart';
import '../../../shared/widgets/service_chip.dart';
import '../../../shared/widgets/star_rating.dart';
import '../../auth/providers/auth_provider.dart';
import '../../coach/providers/coach_provider.dart';
import '../booking_flow.dart';
import '../providers/booking_provider.dart';

class SessionDetailScreen extends ConsumerStatefulWidget {
  const SessionDetailScreen({super.key, this.bookingId, this.slotId});

  final String? bookingId;
  final String? slotId;

  @override
  ConsumerState<SessionDetailScreen> createState() =>
      _SessionDetailScreenState();
}

class _SessionDetailScreenState extends ConsumerState<SessionDetailScreen> {
  int _rating = 5;
  final _commentCtrl = TextEditingController();
  bool _submittingReview = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final fmt = LocaleFormat(locale);
    final profile = ref.watch(currentProfileProvider);
    final isCoach = profile?.role == 'coach';

    if (widget.bookingId != null) {
      final bookingAsync = ref.watch(bookingDetailProvider(widget.bookingId!));
      return bookingAsync.when(
        loading: () =>
            _scaffold(l10n, const Center(child: CircularProgressIndicator())),
        error: (e, _) => _scaffold(l10n, Center(child: Text('$e'))),
        data: (booking) {
          if (booking == null) {
            return _scaffold(l10n, Center(child: Text(l10n.errorOccurred)));
          }
          return _scaffold(
            l10n,
            _BookingSessionBody(
              booking: booking,
              locale: locale,
              fmt: fmt,
              l10n: l10n,
              isCoach: isCoach,
              rating: _rating,
              commentCtrl: _commentCtrl,
              submitting: _submittingReview,
              onRatingChanged: (v) => setState(() => _rating = v),
              onSubmitReview: () => _submitReview(booking),
            ),
          );
        },
      );
    }

    if (widget.slotId != null) {
      final slotAsync = ref.watch(slotSessionProvider(widget.slotId!));
      final bookingsAsync = ref.watch(slotBookingsProvider(widget.slotId!));
      return slotAsync.when(
        loading: () =>
            _scaffold(l10n, const Center(child: CircularProgressIndicator())),
        error: (e, _) => _scaffold(l10n, Center(child: Text('$e'))),
        data: (slot) {
          if (slot == null) {
            return _scaffold(l10n, Center(child: Text(l10n.errorOccurred)));
          }
          final bookings = bookingsAsync.value ?? [];
          final coach = ref.watch(coachDetailProvider(slot.coachId)).value;
          return _scaffold(
            l10n,
            _SlotSessionBody(
              slot: slot,
              bookings: bookings,
              coach: coach,
              locale: locale,
              fmt: fmt,
              l10n: l10n,
              isCoach: isCoach,
            ),
          );
        },
      );
    }

    return _scaffold(l10n, Center(child: Text(l10n.errorOccurred)));
  }

  Scaffold _scaffold(AppLocalizations l10n, Widget body) {
    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      appBar: AppBar(
        title: Text(l10n.sessionDetails),
        backgroundColor: HubStyle.pageBg,
      ),
      body: body,
    );
  }

  Future<void> _submitReview(Booking booking) async {
    setState(() => _submittingReview = true);
    try {
      await ref
          .read(bookingProvider.notifier)
          .submitReview(
            bookingId: booking.id,
            coachId: booking.coachId,
            rating: _rating,
            comment: _commentCtrl.text,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).reviewSubmitted)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
    } finally {
      if (mounted) setState(() => _submittingReview = false);
    }
  }
}

class _BookingSessionBody extends ConsumerWidget {
  const _BookingSessionBody({
    required this.booking,
    required this.locale,
    required this.fmt,
    required this.l10n,
    required this.isCoach,
    required this.rating,
    required this.commentCtrl,
    required this.submitting,
    required this.onRatingChanged,
    required this.onSubmitReview,
  });

  final Booking booking;
  final String locale;
  final LocaleFormat fmt;
  final AppLocalizations l10n;
  final bool isCoach;
  final int rating;
  final TextEditingController commentCtrl;
  final bool submitting;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmitReview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = booking.service ?? booking.slot?.service;
    final slot = booking.slot;
    final coach = booking.coach;
    final reviewAsync = ref.watch(bookingReviewProvider(booking.id));
    final canReview =
        !isCoach &&
        booking.customerId == ref.watch(currentProfileProvider)?.id &&
        (booking.status == 'confirmed' || booking.status == 'completed') &&
        slot != null &&
        slot.endsAt.isBefore(DateTime.now());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SessionHeader(
          service: service,
          slot: slot,
          locale: locale,
          fmt: fmt,
          l10n: l10n,
          status: booking.status,
        ),
        const SizedBox(height: 16),
        _PeopleSection(
          l10n: l10n,
          isCoach: isCoach,
          coachName: coach?.profile?.fullName,
          customerName: booking.customer?.fullName,
        ),
        const SizedBox(height: 16),
        _LocationEquipmentSection(
          service: service,
          coach: coach,
          locale: locale,
          l10n: l10n,
        ),
        if (service?.type == 'virtual_session' &&
            (service?.videoUrl?.isNotEmpty ?? false)) ...[
          const SizedBox(height: 16),
          _VideoSection(service: service!, l10n: l10n),
        ],
        if (canReview) ...[
          const SizedBox(height: 24),
          reviewAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (existing) {
              if (existing != null) {
                return _ExistingReview(review: existing, l10n: l10n);
              }
              return _ReviewForm(
                l10n: l10n,
                rating: rating,
                commentCtrl: commentCtrl,
                submitting: submitting,
                onRatingChanged: onRatingChanged,
                onSubmit: onSubmitReview,
              );
            },
          ),
        ] else if (!isCoach &&
            booking.customerId == ref.watch(currentProfileProvider)?.id &&
            slot != null &&
            !slot.endsAt.isBefore(DateTime.now())) ...[
          const SizedBox(height: 16),
          Text(l10n.reviewAfterSession, style: HubStyle.bodyMuted),
        ],
      ],
    );
  }
}

class _SlotSessionBody extends StatelessWidget {
  const _SlotSessionBody({
    required this.slot,
    required this.bookings,
    required this.coach,
    required this.locale,
    required this.fmt,
    required this.l10n,
    required this.isCoach,
  });

  final TimeSlot slot;
  final List<Booking> bookings;
  final Coach? coach;
  final String locale;
  final LocaleFormat fmt;
  final AppLocalizations l10n;
  final bool isCoach;

  @override
  Widget build(BuildContext context) {
    final service = slot.service;
    final max = service?.maxParticipants ?? 1;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SessionHeader(
          service: service,
          slot: slot,
          locale: locale,
          fmt: fmt,
          l10n: l10n,
          bookedCount: slot.bookedCount,
          maxParticipants: max,
        ),
        const SizedBox(height: 16),
        _LocationEquipmentSection(
          service: service,
          coach: coach,
          locale: locale,
          l10n: l10n,
        ),
        if (bookings.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(l10n.participants, style: HubStyle.calendarEyebrow),
          const SizedBox(height: 8),
          ...bookings.map(
            (b) => HubCard(
              margin: const EdgeInsets.only(bottom: 8),
              onTap: () => openSession(context, b.id),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      b.customer?.fullName ?? l10n.customer,
                      style: HubStyle.timelineTitle,
                    ),
                  ),
                  Text(
                    l10n.bookingStatus(b.status),
                    style: HubStyle.timelineMeta,
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: HubStyle.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({
    required this.service,
    required this.slot,
    required this.locale,
    required this.fmt,
    required this.l10n,
    this.status,
    this.bookedCount,
    this.maxParticipants,
  });

  final Service? service;
  final TimeSlot? slot;
  final String locale;
  final LocaleFormat fmt;
  final AppLocalizations l10n;
  final String? status;
  final int? bookedCount;
  final int? maxParticipants;

  @override
  Widget build(BuildContext context) {
    final title = service != null ? service!.localTitle(locale) : l10n.session;

    return HubCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (service != null) ...[
            ServiceChip(type: service!.type, small: true),
            const SizedBox(height: 10),
          ],
          Text(title, style: HubStyle.calendarHeadline.copyWith(fontSize: 20)),
          if (slot != null) ...[
            const SizedBox(height: 8),
            Text(
              fmt.displayDateWithTime(slot!.startsAt),
              style: HubStyle.timelineMeta,
            ),
            Text(
              fmt.timeRange(slot!.startsAt, slot!.endsAt),
              style: HubStyle.timelineMeta,
            ),
          ],
          if (status != null) ...[
            const SizedBox(height: 10),
            Text(l10n.bookingStatus(status!), style: HubStyle.timelineMeta),
          ],
          if (bookedCount != null && maxParticipants != null) ...[
            const SizedBox(height: 6),
            Text(
              '$bookedCount/$maxParticipants ${l10n.playersBooked}',
              style: HubStyle.timelineMeta,
            ),
          ],
        ],
      ),
    );
  }
}

class _PeopleSection extends StatelessWidget {
  const _PeopleSection({
    required this.l10n,
    required this.isCoach,
    this.coachName,
    this.customerName,
  });

  final AppLocalizations l10n;
  final bool isCoach;
  final String? coachName;
  final String? customerName;

  @override
  Widget build(BuildContext context) {
    return HubCard(
      child: Column(
        children: [
          if (!isCoach)
            _InfoRow(
              icon: Icons.sports_tennis,
              label: l10n.coach,
              value: coachName ?? '—',
            ),
          if (isCoach && customerName != null)
            _InfoRow(
              icon: Icons.person_outline,
              label: l10n.customer,
              value: customerName!,
            ),
        ],
      ),
    );
  }
}

class _LocationEquipmentSection extends StatelessWidget {
  const _LocationEquipmentSection({
    required this.service,
    required this.coach,
    required this.locale,
    required this.l10n,
  });

  final Service? service;
  final Coach? coach;
  final String locale;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final location = service?.localLocation(locale);
    final fallbackLocation = coach?.location;
    final displayLocation = (location != null && location.isNotEmpty)
        ? location
        : (fallbackLocation ?? '');

    final equipment = service?.localEquipment(locale);

    return HubCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: l10n.sessionLocation,
            value: displayLocation.isNotEmpty
                ? displayLocation
                : l10n.noLocationListed,
          ),
          const Divider(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: HubStyle.hubOlive,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.requiredEquipment,
                      style: HubStyle.timelineTitle.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      equipment != null && equipment.isNotEmpty
                          ? equipment
                          : l10n.noEquipmentListed,
                      style: HubStyle.bodyMuted.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: HubStyle.hubOlive),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: HubStyle.timelineTitle.copyWith(fontSize: 13),
                ),
                Text(value, style: HubStyle.bodyMuted.copyWith(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoSection extends StatelessWidget {
  const _VideoSection({required this.service, required this.l10n});

  final Service service;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return HubCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(service.videoPlatform ?? 'Video', style: HubStyle.timelineTitle),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => launchUrl(Uri.parse(service.videoUrl!)),
            icon: const Icon(Icons.videocam_outlined),
            label: Text(service.videoUrl!),
          ),
        ],
      ),
    );
  }
}

class _ReviewForm extends StatelessWidget {
  const _ReviewForm({
    required this.l10n,
    required this.rating,
    required this.commentCtrl,
    required this.submitting,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  final AppLocalizations l10n;
  final int rating;
  final TextEditingController commentCtrl;
  final bool submitting;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return HubCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.leaveReview,
            style: HubStyle.calendarHeadline.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (i) {
              final star = i + 1;
              return IconButton(
                onPressed: () => onRatingChanged(star),
                icon: Icon(
                  star <= rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
              );
            }),
          ),
          TextField(
            controller: commentCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: l10n.writeReviewHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: submitting ? null : onSubmit,
              child: submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.submitReview),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExistingReview extends StatelessWidget {
  const _ExistingReview({required this.review, required this.l10n});

  final Review review;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return HubCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.yourReview,
            style: HubStyle.calendarHeadline.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          StarRating(rating: review.rating.toDouble(), size: 20),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review.comment!, style: HubStyle.bodyMuted),
          ],
        ],
      ),
    );
  }
}
