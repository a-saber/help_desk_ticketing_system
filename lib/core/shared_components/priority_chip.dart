import 'package:flutter/material.dart';
import 'package:help_desk_ticketing_system/core/translation/translation_helper.dart';
import '../../core/theme/app_colors.dart';

import '../../features/tickets/data/models/enums.dart';

class PriorityChip extends StatelessWidget {
  final TicketPriority priority;
  const PriorityChip({super.key, required this.priority});

  Color _color() {
    switch (priority) {
      case TicketPriority.low:
        return AppColors.success;
      case TicketPriority.medium:
        return AppColors.warning;
      case TicketPriority.high:
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          priority.label(context.isArabic),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
