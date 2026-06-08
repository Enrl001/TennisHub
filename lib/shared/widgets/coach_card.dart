import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../features/booking/booking_flow.dart';
import '../../l10n/app_localizations.dart';
import '../models/models.dart';
import 'hub_ui.dart';
import 'service_chip.dart';
import 'star_rating.dart';

class CoachCard extends ConsumerWidget {
  const CoachCard({super.key, required this.coach});

  final Coach coach;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = coach.profile;
    final services = coach.services ?? [];
    final minPrice = services.isEmpty
        ? null
        : services
              .map((s) => s.priceAmount ?? 0.0)
              .reduce((a, b) => a < b ? a : b);

    return HubCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      onTap: () => openCoachDetail(context, coach.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(url: profile?.avatarUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.fullName ?? l10n.coach,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: HubStyle.textPrimary,
                      ),
                    ),
                    if (coach.location != null) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: HubStyle.textMuted,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              coach.location!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: HubStyle.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    StarRating(rating: coach.avgRating ?? 0.0),
                  ],
                ),
              ),
            ],
          ),
          if (services.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: services
                  .take(3)
                  .map((s) => ServiceChip(type: s.type, small: true))
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (minPrice != null)
                Text(
                  '${minPrice.toStringAsFixed(0)} ${services.first.currency ?? 'MNT'}${l10n.perHour}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: HubStyle.hubOlive,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              const Spacer(),
              FilledButton(
                onPressed: () => openCoachDetail(context, coach.id),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(90, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text(l10n.bookNow),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: CachedNetworkImage(
          imageUrl: url!,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          placeholder: (_, __) => _placeholder(),
          errorWidget: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      color: HubStyle.hubOlive.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(28),
    ),
    child: const Icon(Icons.person, color: HubStyle.hubOlive, size: 28),
  );
}
