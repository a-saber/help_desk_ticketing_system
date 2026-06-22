import 'package:flutter/material.dart';

import '../../../../core/helper/date_formatter.dart';
import '../../data/models/ticket_history_model.dart';

class CommentTile extends StatelessWidget {
  final TicketHistoryModel item;
  const CommentTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        radius: 16,
        child: Icon(Icons.history, size: 16),
      ),
      title: Text(item.message, style: const TextStyle(fontSize: 13)),
      subtitle: Text(
        DateFormatter.toDisplay(item.createdAt),
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}
