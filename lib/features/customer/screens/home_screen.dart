import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/coach_card.dart';
import '../../../shared/widgets/hub_ui.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../coach/providers/coach_provider.dart';
import '../providers/filter_provider.dart';
import '../widgets/filter_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final coachesAsync = ref.watch(coachesProvider);
    final activeFilter = ref.watch(serviceTypeFilterProvider);

    return HubScreen(
      appBar: HubBrandAppBar(
        title: 'MY CLUB',
        actions: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_none),
            tooltip: l10n.notifications,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Consumer(
                    builder: (_, ref, __) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: l10n.searchCoaches,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: HubStyle.hubOlive,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        onChanged: (v) =>
                            ref.read(searchQueryProvider.notifier).setQuery(v),
                      );
                    },
                  ),
                ),
                FilterBar(
                  activeFilter: activeFilter,
                  onFilterChanged: (f) =>
                      ref.read(serviceTypeFilterProvider.notifier).setFilter(f),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          coachesAsync.when(
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, __) => const CoachCardShimmer(),
                childCount: 5,
              ),
            ),
            error: (e, __) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: HubStyle.textMuted,
                    ),
                    const SizedBox(height: 12),
                    Text(l10n.errorOccurred, style: HubStyle.bodyMuted),
                    const SizedBox(height: 16),
                    HubPrimaryButton(
                      label: l10n.retry,
                      onPressed: () => ref.refresh(coachesProvider),
                      minimumHeight: 44,
                    ),
                  ],
                ),
              ),
            ),
            data: (coaches) => coaches.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 56,
                            color: HubStyle.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.noCoachesFound,
                            style: HubStyle.bodyMuted,
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => CoachCard(coach: coaches[i]),
                      childCount: coaches.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
