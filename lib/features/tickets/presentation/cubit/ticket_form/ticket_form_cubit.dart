import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/enums.dart';
import '../../../data/repo/ticket_repository.dart';
import 'ticket_form_state.dart';

class TicketFormCubit extends Cubit<TicketFormState> {
  final TicketRepository ticketRepository;

  TicketFormCubit({required this.ticketRepository})
    : super(const TicketFormState());
  static TicketFormCubit get(context) =>
      BlocProvider.of<TicketFormCubit>(context);

  void changePriority(TicketPriority priority) =>
      emit(state.copyWith(priority: priority));

  void changeCategory(TicketCategory category) =>
      emit(state.copyWith(category: category));

  Future<void> submit({
    required String subject,
    required String description,
  }) async {
    emit(state.copyWith(status: TicketFormStatus.submitting));
    try {
      final ticket = await ticketRepository.createTicket(
        subject: subject,
        description: description,
        priority: state.priority,
        category: state.category,
      );
      emit(
        state.copyWith(status: TicketFormStatus.success, savedTicket: ticket),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TicketFormStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
