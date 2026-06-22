import 'package:equatable/equatable.dart';

import '../../../data/models/ticket_history_model.dart';
import '../../../data/models/ticket_model.dart';

enum TicketDetailStatus { loading, loaded, updating, deleted, error }

class TicketDetailState extends Equatable {
  final TicketDetailStatus status;
  final TicketModel ticket;
  final List<TicketHistoryModel> history;
  final String? errorMessage;

  const TicketDetailState({
    required this.status,
    required this.ticket,
    this.history = const [],
    this.errorMessage,
  });

  TicketDetailState copyWith({
    TicketDetailStatus? status,
    TicketModel? ticket,
    List<TicketHistoryModel>? history,
    String? errorMessage,
  }) {
    return TicketDetailState(
      status: status ?? this.status,
      ticket: ticket ?? this.ticket,
      history: history ?? this.history,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, ticket, history, errorMessage];
}
