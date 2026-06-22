import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../../../core/helper/ticket_number_generator.dart';
import '../data_sources/ticket_local_datasource.dart';
import '../models/enums.dart';
import '../models/ticket_history_model.dart';
import '../models/ticket_model.dart';
import 'ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketLocalDataSource localDataSource;

  TicketRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TicketModel>> getAllTickets() => localDataSource.getAllTickets();

  @override
  Future<TicketModel?> getTicketById(int id) =>
      localDataSource.getTicketById(id);

  @override
  Future<TicketModel> createTicket({
    required String subject,
    required String description,
    required TicketPriority priority,
    required TicketCategory category,
  }) async {
    final now = DateTime.now();
    final ticket = TicketModel(
      ticketNumber: TicketNumberGenerator.generate(),
      subject: subject.trim(),
      description: description.trim(),
      priority: priority,
      category: category,
      status: TicketStatus.open,
      createdAt: now,
      updatedAt: now,
    );

    final id = await localDataSource.insertTicket(ticket);
    final saved = ticket._withId(id);

    await localDataSource.insertHistory(
      TicketHistoryModel(
        ticketId: id,
        message: 'Ticket created with status Open',
        createdAt: now,
      ),
    );

    return saved;
  }

  @override
  Future<void> updateTicketFields(
    TicketModel ticket, {
    String? subject,
    String? description,
    TicketPriority? priority,
  }) async {
    final changes = <String>[];
    if (subject != null && subject.trim() != ticket.subject) {
      changes.add('Subject updated');
    }
    if (description != null && description.trim() != ticket.description) {
      changes.add('Description updated');
    }
    if (priority != null && priority != ticket.priority) {
      changes.add('Priority changed to ${priority.name}');
    }

    final updated = ticket.copyWith(
      subject: subject,
      description: description,
      priority: priority,
      updatedAt: DateTime.now(),
    );

    await localDataSource.updateTicket(updated);

    for (final change in changes) {
      await localDataSource.insertHistory(
        TicketHistoryModel(
          ticketId: ticket.id!,
          message: change,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> changeStatus(TicketModel ticket, TicketStatus newStatus) async {
    if (ticket.status == newStatus) return;

    final updated = ticket.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    await localDataSource.updateTicket(updated);

    await localDataSource.insertHistory(
      TicketHistoryModel(
        ticketId: ticket.id!,
        message:
            'Status changed from ${ticket.status.name} to ${newStatus.name}',
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> deleteTicket(int id) => localDataSource.deleteTicket(id);

  @override
  Future<List<TicketHistoryModel>> getHistory(int ticketId) =>
      localDataSource.getHistory(ticketId);

  @override
  Future<String> exportTicketsToJson() async {
    final tickets = await getAllTickets();
    final jsonList = tickets.map((t) => t.toJson()).toList();
    final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);

    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        'tickets_export_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(jsonString);

    return file.path;
  }
}

extension on TicketModel {
  TicketModel _withId(int id) => TicketModel(
    id: id,
    ticketNumber: ticketNumber,
    subject: subject,
    description: description,
    priority: priority,
    category: category,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
