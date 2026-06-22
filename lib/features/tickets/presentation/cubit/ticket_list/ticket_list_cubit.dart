import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/enums.dart';
import '../../../data/repo/ticket_repository.dart';
import 'ticket_list_state.dart';

class TicketListCubit extends Cubit<TicketListState> {
  final TicketRepository ticketRepository;

  TicketListCubit({required this.ticketRepository})
    : super(const TicketListState());

  Future<void> loadTickets() async {
    emit(state.copyWith(status: TicketListStatus.loading));
    try {
      final tickets = await ticketRepository.getAllTickets();
      emit(
        state.copyWith(status: TicketListStatus.loaded, allTickets: tickets),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TicketListStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void filterByStatus(TicketStatus? status) {
    if (status == null) {
      emit(state.copyWith(clearStatusFilter: true));
    } else {
      emit(state.copyWith(statusFilter: status));
    }
  }

  void changeSortOrder(SortOrder order) {
    emit(state.copyWith(sortOrder: order));
  }

  Future<void> deleteTicket(int id) async {
    await ticketRepository.deleteTicket(id);
    await loadTickets();
  }

  Future<String> exportToJson() => ticketRepository.exportTicketsToJson();
}
