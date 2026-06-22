import 'package:sqflite/sqflite.dart';

import '../../../../core/local_db/database_helper.dart';
import '../../../../core/services/service_locator.dart';
import '../models/ticket_history_model.dart';
import '../models/ticket_model.dart';

/// Talks to SQflite directly. Nothing above this layer (repository,
/// cubits, UI) should ever import `sqflite` — that's the whole point of
/// isolating persistence behind a datasource (Dependency Inversion).
abstract class TicketLocalDataSource {
  Future<List<TicketModel>> getAllTickets();
  Future<TicketModel?> getTicketById(int id);
  Future<int> insertTicket(TicketModel ticket);
  Future<void> updateTicket(TicketModel ticket);
  Future<void> deleteTicket(int id);

  Future<List<TicketHistoryModel>> getHistory(int ticketId);
  Future<void> insertHistory(TicketHistoryModel history);
}

class TicketLocalDataSourceImpl implements TicketLocalDataSource {
  final DatabaseHelper databaseHelper;

  TicketLocalDataSourceImpl({DatabaseHelper? databaseHelper})
    : databaseHelper = databaseHelper ?? getIt.get<DatabaseHelper>();

  static const String _table = 'tickets';
  static const String _historyTable = 'ticket_history';

  Future<Database> get _db async => databaseHelper.database;

  @override
  Future<List<TicketModel>> getAllTickets() async {
    final db = await _db;
    final rows = await db.query(_table, orderBy: 'createdAt DESC');
    return rows.map(TicketModel.fromMap).toList();
  }

  @override
  Future<TicketModel?> getTicketById(int id) async {
    final db = await _db;
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return TicketModel.fromMap(rows.first);
  }

  @override
  Future<int> insertTicket(TicketModel ticket) async {
    final db = await _db;
    return db.insert(_table, ticket.toMap());
  }

  @override
  Future<void> updateTicket(TicketModel ticket) async {
    final db = await _db;
    await db.update(
      _table,
      ticket.toMap(),
      where: 'id = ?',
      whereArgs: [ticket.id],
    );
  }

  @override
  Future<void> deleteTicket(int id) async {
    final db = await _db;
    await db.delete(_historyTable, where: 'ticketId = ?', whereArgs: [id]);
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<TicketHistoryModel>> getHistory(int ticketId) async {
    final db = await _db;
    final rows = await db.query(
      _historyTable,
      where: 'ticketId = ?',
      whereArgs: [ticketId],
      orderBy: 'createdAt DESC',
    );
    return rows.map(TicketHistoryModel.fromMap).toList();
  }

  @override
  Future<void> insertHistory(TicketHistoryModel history) async {
    final db = await _db;
    await db.insert(_historyTable, history.toMap());
  }
}
