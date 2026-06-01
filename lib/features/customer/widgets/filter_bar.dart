import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key, required this.activeFilter, required this.onFilterChanged});

  final String? activeFilter;
  final ValueChanged<String?> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filters = <String?, String>{
      null: l10n.filterAll,
      'private_lesson': l10n.filterPrivate,
      'group_lesson': l10n.filterGroup,
      'community_event': l10n.filterCommunity,
      'virtual_session': l10n.filterVirtual,
    };

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: filters.entries.map((e) {
          final selected = activeFilter == e.key;
          final color = e.key == null ? AppColors.primary : AppColors.serviceColor(e.key!);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(e.value),
              selected: selected,
              onSelected: (_) => onFilterChanged(e.key),
              selectedColor: color.withOpacity(0.15),
              checkmarkColor: color,
              labelStyle: TextStyle(
                color: selected ? color : Colors.grey,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(color: selected ? color : AppColors.cardBorder),
            ),
          );
        }).toList(),
      ),
    );
  }
}
