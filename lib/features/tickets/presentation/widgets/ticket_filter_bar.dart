import 'package:flutter/material.dart';
import 'package:help_desk_ticketing_system/core/translation/translation_helper.dart';

import '../../data/models/enums.dart';

class TicketFilterBar extends StatelessWidget {
  final TicketStatus? statusFilter;
  final SortOrder sortOrder;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<TicketStatus?> onStatusChanged;
  final ValueChanged<SortOrder> onSortChanged;

  const TicketFilterBar({
    super.key,
    required this.statusFilter,
    required this.sortOrder,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: context.tr('search_by_subject'),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<TicketStatus?>(
                value: statusFilter,
                decoration: InputDecoration(
                  labelText: context.tr('filter_by_status'),
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text(context.tr('all'))),
                  ...TicketStatus.values.map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.label(isArabic)),
                    ),
                  ),
                ],
                onChanged: onStatusChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<SortOrder>(
                value: sortOrder,
                decoration: InputDecoration(
                  labelText: context.tr('sort_by_date'),
                ),
                items: [
                  DropdownMenuItem(
                    value: SortOrder.newestFirst,
                    child: Text(context.tr('newest_first')),
                  ),
                  DropdownMenuItem(
                    value: SortOrder.oldestFirst,
                    child: Text(context.tr('oldest_first')),
                  ),
                ],
                onChanged: (value) =>
                    onSortChanged(value ?? SortOrder.newestFirst),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
