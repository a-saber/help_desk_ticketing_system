import '../models/enums.dart';
import '../models/ticket_history_model.dart';
import '../models/ticket_model.dart';

/// Contract the presentation layer (cubits) depends on. Cubits never know
/// SQflite exists — they only know this interface. This is what lets us
/// unit test cubits with a fake/mock repository instead of a real DB.
abstract class TicketRepository {
  Future<List<TicketModel>> getAllTickets();

  Future<TicketModel?> getTicketById(int id);

  Future<TicketModel> createTicket({
    required String subject,
    required String description,
    required TicketPriority priority,
    required TicketCategory category,
  });

  Future<void> updateTicketFields(
    TicketModel ticket, {
    String? subject,
    String? description,
    TicketPriority? priority,
  });

  Future<void> changeStatus(TicketModel ticket, TicketStatus newStatus);

  Future<void> deleteTicket(int id);

  Future<List<TicketHistoryModel>> getHistory(int ticketId);

  /// Bonus feature: exports all tickets to a JSON file and returns its path.
  Future<String> exportTicketsToJson();
}
