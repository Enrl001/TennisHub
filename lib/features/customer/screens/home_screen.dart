import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/coach_card.dart';
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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Row(children: [
              const Icon(Icons.sports_tennis, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('MyClub',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      )),
            ]),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(116),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Consumer(builder: (_, ref, __) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: l10n.searchCoaches,
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: (v) =>
                            ref.read(searchQueryProvider.notifier).setQuery(v),
                      );
                    }),
                  ),
                  FilterBar(
                    activeFilter: activeFilter,
                    onFilterChanged: (f) =>
                        ref.read(serviceTypeFilterProvider.notifier).setFilter(f),
                  ),
                ],
              ),
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
                    const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(l10n.errorOccurred),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.refresh(coachesProvider),
                      style: ElevatedButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10)),
                      child: Text(l10n.retry),
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
                          const Icon(Icons.search_off, size: 56, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(l10n.noCoachesFound,
                              style: const TextStyle(color: Colors.grey, fontSize: 16)),
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
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }
}
