import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/extensions/local_ext.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/hub_ui.dart';
import '../../../shared/widgets/service_chip.dart';
import '../../../shared/widgets/star_rating.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/booking_flow.dart';
import '../../coach/providers/coach_provider.dart';

class CoachDetailScreen extends ConsumerWidget {
  const CoachDetailScreen({super.key, required this.coachId});

  final String coachId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final coachAsync = ref.watch(coachDetailProvider(coachId));
    final reviewsAsync = ref.watch(coachReviewsProvider(coachId));

    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      body: coachAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text(e.toString())),
        data: (coach) {
          final profile = coach.profile;
          final services = coach.services ?? [];
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: profile?.avatarUrl != null
                      ? CachedNetworkImage(
                          imageUrl: profile!.avatarUrl!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: HubStyle.hubOlive.withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.person,
                            size: 80,
                            color: HubStyle.hubOlive,
                          ),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile?.fullName ?? l10n.coach,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                if (coach.location != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        coach.location!,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StarRating(
                                rating: coach.avgRating ?? 0.0,
                                size: 18,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.reviewCount(coach.totalReviews ?? 0),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (coach.yearsExperience != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.workspace_premium_outlined,
                              size: 14,
                              color: HubStyle.hubOlive,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.experienceYears(coach.yearsExperience!),
                              style: const TextStyle(
                                fontSize: 13,
                                color: HubStyle.hubOlive,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),
                      _SectionTitle(title: l10n.about),
                      const SizedBox(height: 8),
                      Text(
                        coach.localBio(locale).isEmpty
                            ? l10n.noBioProvided
                            : coach.localBio(locale),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      if ((coach.certifications ?? []).isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _SectionTitle(title: l10n.certifications),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: (coach.certifications ?? [])
                              .map(
                                (c) => Chip(
                                  label: Text(
                                    c,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 24),
                      _SectionTitle(title: l10n.services),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _ServiceTile(
                    service: services[i],
                    locale: locale,
                    onBook: () =>
                        openBooking(context, services[i].id),
                  ),
                  childCount: services.length,
                ),
              ),
              if (services.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Center(
                      child: Text(
                        l10n.noServicesYet,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _SectionTitle(title: l10n.reviews),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              reviewsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
                data: (reviews) => reviews.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              l10n.noReviews,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => _ReviewTile(review: reviews[i]),
                          childCount: reviews.length,
                        ),
                      ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title.toUpperCase(),
    style: HubStyle.calendarEyebrow,
  );
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.locale,
    required this.onBook,
  });
  final Service service;
  final String locale;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return HubCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceChip(type: service.type, small: true),
                  const SizedBox(height: 8),
                  Text(
                    service.localTitle(locale),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (service.durationMinutes != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 13,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.minutes(service.durationMinutes!),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (service.priceAmount != null)
                  Text(
                    '${service.priceAmount!.toStringAsFixed(0)} ${service.currency ?? 'USD'}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: HubStyle.hubOlive,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: onBook,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(80, 34),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    l10n.bookNow,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});
  final review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: HubStyle.hubOlive.withValues(alpha: 0.1),
            child: Text(
              (review.customer?.fullName ?? 'A')[0].toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review.customer?.fullName ?? 'Anonymous',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    ...List.generate(
                      5,
                      (i) => Icon(
                        i < review.rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 14,
                        color: const Color(0xFFFB8C00),
                      ),
                    ),
                  ],
                ),
                if (review.comment != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    review.comment!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
