import 'package:equatable/equatable.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/ticket_model.dart';

enum TicketFormStatus { idle, submitting, success, error }

class TicketFormState extends Equatable {
  final TicketFormStatus status;
  final TicketPriority priority;
  final TicketCategory category;
  final TicketModel? savedTicket;
  final String? errorMessage;

  const TicketFormState({
    this.status = TicketFormStatus.idle,
    this.priority = TicketPriority.medium,
    this.category = TicketCategory.general,
    this.savedTicket,
    this.errorMessage,
  });

  TicketFormState copyWith({
    TicketFormStatus? status,
    TicketPriority? priority,
    TicketCategory? category,
    TicketModel? savedTicket,
    String? errorMessage,
  }) {
    return TicketFormState(
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      savedTicket: savedTicket ?? this.savedTicket,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    priority,
    category,
    savedTicket,
    errorMessage,
  ];
}
