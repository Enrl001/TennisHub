import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/locale_format.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/extensions/local_ext.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/service_chip.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/providers/booking_provider.dart';
import '../../coach/providers/coach_provider.dart';

class CoachDashboardScreen extends ConsumerWidget {
  const CoachDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final isMn = locale == 'mn';
    final profile = ref.watch(currentProfileProvider);
    final bookingsAsync = ref.watch(coachBookingsProvider);
    final servicesAsync = ref.watch(myCoachServicesProvider);
    final bookings = bookingsAsync.value ?? [];
    final services = servicesAsync.value ?? [];
    final now = DateTime.now();

    final activeBookings =
        bookings
            .where((b) => b.status == 'confirmed' || b.status == 'pending')
            .where((b) => (b.slot?.startsAt ?? now).isAfter(now))
            .toList()
          ..sort(
            (a, b) => (a.slot?.startsAt ?? DateTime(0)).compareTo(
              b.slot?.startsAt ?? DateTime(0),
            ),
          );
    final nextBooking = activeBookings.isNotEmpty ? activeBookings.first : null;
    final totalEarnings = bookings
        .where((b) => b.status == 'confirmed' || b.status == 'completed')
        .fold<double>(0, (sum, b) => sum + (b.amountPaid ?? 0));
    final traineeCount = bookings
        .map((b) => b.customerId)
        .where((id) => id.isNotEmpty)
        .toSet()
        .length;

    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      appBar: AppBar(
        backgroundColor: HubStyle.pageBg,
        toolbarHeight: 64,
        titleSpacing: 16,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: HubStyle.hubOlive.withValues(alpha: 0.12),
              backgroundImage: profile?.avatarUrl != null
                  ? NetworkImage(profile!.avatarUrl!)
                  : null,
              child: profile?.avatarUrl == null
                  ? Text(
                      (profile?.fullName?.trim().isNotEmpty ?? false)
                          ? profile!.fullName!.trim()[0].toUpperCase()
                          : 'C',
                      style: const TextStyle(
                        color: HubStyle.hubOlive,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            const Text('COACH HUB', style: HubStyle.brandTitle),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/coach-notifications'),
            icon: const Icon(Icons.notifications_none, color: HubStyle.hubOlive),
            tooltip: l10n.notifications,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(coachBookingsProvider);
          ref.invalidate(myCoachServicesProvider);
          await Future.wait([
            ref.read(coachBookingsProvider.future),
            ref.read(myCoachServicesProvider.future),
          ]);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
          children: [
            _NextSessionCard(booking: nextBooking, locale: locale),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _TopActionButton(
                    icon: Icons.add_circle_outline,
                    label: l10n.addService,
                    onTap: () => context.push('/add-service'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TopActionButton(
                    icon: Icons.calendar_month_outlined,
                    label: isMn ? 'Цаг нэмэх' : 'Add Slot',
                    onTap: () => context.push('/add-slot'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _StatsRow(
              earnings: totalEarnings,
              traineeCount: traineeCount,
              sessionCount: activeBookings.length,
              isMn: isMn,
            ),
            const SizedBox(height: 22),
            _DashboardServices(
              servicesAsync: servicesAsync,
              services: services,
              locale: locale,
            ),
          ],
        ),
      ),
    );
  }
}

class _NextSessionCard extends StatelessWidget {
  const _NextSessionCard({required this.booking, required this.locale});

  final Booking? booking;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fmt = LocaleFormat(locale);
    final service = booking?.service ?? booking?.slot?.service;
    final slot = booking?.slot;
    final title = service == null
        ? (fmt.isMn ? 'Дараагийн хичээл алга' : 'No upcoming session')
        : (fmt.isMn ? (service.titleMn ?? service.title) : service.title);
    final time = slot == null
        ? (fmt.isMn ? 'Хуваарь хоосон байна' : 'Schedule is clear')
        : fmt.timeRange(slot.startsAt, slot.endsAt);
    final startsIn = slot == null
        ? null
        : slot.startsAt.difference(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HubStyle.accentLime,
        borderRadius: BorderRadius.circular(HubStyle.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fmt.isMn ? 'ДАРААГИЙН ХИЧЭЭЛ' : 'UPCOMING SESSION',
            style: const TextStyle(
              color: HubStyle.hubOliveDark,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF161616),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: HubStyle.hubOlive),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  time,
                  style: const TextStyle(
                    color: HubStyle.hubOlive,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (startsIn != null && startsIn.inMinutes >= 0) ...[
            const SizedBox(height: 14),
            Text(
              l10n.startsInMinutes(startsIn.inMinutes),
              style: const TextStyle(
                color: Color(0xFF2D3400),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HubStyle.darkPanel,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.tennisGreen, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.earnings,
    required this.traineeCount,
    required this.sessionCount,
    required this.isMn,
  });

  final double earnings;
  final int traineeCount;
  final int sessionCount;
  final bool isMn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: isMn ? 'Орлого' : 'Daily Earnings',
            value: '\$${earnings.toStringAsFixed(0)}',
            caption: isMn
                ? '$sessionCount идэвхтэй хичээл'
                : '$sessionCount active sessions',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: isMn ? 'Сурагчид' : 'Active Trainees',
            value: '$traineeCount',
            caption: isMn ? 'Энэ долоо хоног' : 'This week',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4E6DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF181A20),
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardServices extends StatelessWidget {
  const _DashboardServices({
    required this.servicesAsync,
    required this.services,
    required this.locale,
  });

  final AsyncValue<List<Service>> servicesAsync;
  final List<Service> services;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMn = locale == 'mn';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.services),
        const SizedBox(height: 8),
        servicesAsync.when(
          loading: () => _EmptyText(
            text: isMn ? 'Үйлчилгээ ачаалж байна' : 'Loading services',
          ),
          error: (_, __) => _EmptyText(text: l10n.noServicesYet),
          data: (_) {
            if (services.isEmpty) {
              return _EmptyText(text: l10n.noServicesYet);
            }
            return Column(
              children: services
                  .map(
                    (service) => _ServiceRow(
                      service: service,
                      locale: locale,
                      onSlot: () =>
                          context.push('/add-slot?serviceId=${service.id}'),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.locale,
    required this.onSlot,
  });

  final Service service;
  final String locale;
  final VoidCallback onSlot;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4E6DC)),
      ),
      child: Row(
        children: [
          ServiceChip(type: service.type, small: true),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.localTitle(locale),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${service.durationMinutes ?? 60} min',
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${service.priceAmount?.toStringAsFixed(0) ?? '0'} ${service.currency ?? 'USD'}',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          IconButton(
            onPressed: onSlot,
            icon: const Icon(Icons.schedule, color: AppColors.primary),
            tooltip: locale == 'mn' ? 'Цаг нэмэх' : 'Add Slot',
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF181A20),
        fontSize: 17,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4E6DC)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
      ),
    );
  }
}
