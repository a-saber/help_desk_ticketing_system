import 'package:flutter/material.dart';
import 'package:help_desk_ticketing_system/core/translation/translation_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../features/tickets/data/models/enums.dart';

/// Reusable colored chip for a ticket's status. Used in the list, the
/// detail screen, and could be reused anywhere else a status needs to be
/// shown — single definition, single source of truth for status colors.
class StatusChip extends StatelessWidget {
  final TicketStatus status;
  const StatusChip({super.key, required this.status});

  Color _color() {
    switch (status) {
      case TicketStatus.open:
        return AppColors.info;
      case TicketStatus.inProgress:
        return AppColors.warning;
      case TicketStatus.closed:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label(context.isArabic),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
