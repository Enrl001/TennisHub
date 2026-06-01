import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/extensions.dart';

class ServiceChip extends StatelessWidget {
  const ServiceChip({super.key, required this.type, this.small = false});

  final String type;
  final bool small;

  IconData _icon() {
    switch (type) {
      case 'private_lesson': return Icons.person;
      case 'group_lesson': return Icons.group;
      case 'community_event': return Icons.event;
      case 'virtual_session': return Icons.videocam;
      default: return Icons.sports_tennis;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.serviceColor(type);
    final fontSize = small ? 11.0 : 12.0;
    final padding = small
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 3)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 5);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon(), size: small ? 12 : 14, color: color),
          const SizedBox(width: 4),
          Text(
            type.serviceTypeLabel(),
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
