import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/ticket_model.dart';
import '../../../data/repo/ticket_repository.dart';
import 'ticket_detail_state.dart';

class TicketDetailCubit extends Cubit<TicketDetailState> {
  final TicketRepository ticketRepository;

  TicketDetailCubit({
    required this.ticketRepository,
    required TicketModel initialTicket,
  }) : super(
         TicketDetailState(
           status: TicketDetailStatus.loading,
           ticket: initialTicket,
         ),
       ) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final history = await ticketRepository.getHistory(state.ticket.id!);
      emit(state.copyWith(status: TicketDetailStatus.loaded, history: history));
    } catch (e) {
      emit(
        state.copyWith(
          status: TicketDetailStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> changeStatus(TicketStatus newStatus) async {
    emit(state.copyWith(status: TicketDetailStatus.updating));
    await ticketRepository.changeStatus(state.ticket, newStatus);
    final refreshed = await ticketRepository.getTicketById(state.ticket.id!);
    emit(
      state.copyWith(
        status: TicketDetailStatus.loaded,
        ticket: refreshed ?? state.ticket,
      ),
    );
    await loadHistory();
  }

  Future<void> updateFields({
    String? subject,
    String? description,
    TicketPriority? priority,
  }) async {
    emit(state.copyWith(status: TicketDetailStatus.updating));
    await ticketRepository.updateTicketFields(
      state.ticket,
      subject: subject,
      description: description,
      priority: priority,
    );
    final refreshed = await ticketRepository.getTicketById(state.ticket.id!);
    emit(
      state.copyWith(
        status: TicketDetailStatus.loaded,
        ticket: refreshed ?? state.ticket,
      ),
    );
    await loadHistory();
  }

  Future<void> deleteTicket() async {
    emit(state.copyWith(status: TicketDetailStatus.updating));
    await ticketRepository.deleteTicket(state.ticket.id!);
    emit(state.copyWith(status: TicketDetailStatus.deleted));
  }
}
