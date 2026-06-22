import 'package:equatable/equatable.dart';

import '../../../../core/helper/date_formatter.dart';

class TicketHistoryModel extends Equatable {
  final int? id;
  final int ticketId;
  final String message;
  final DateTime createdAt;

  const TicketHistoryModel({
    this.id,
    required this.ticketId,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'ticketId': ticketId,
      'message': message,
      'createdAt': DateFormatter.toDbString(createdAt),
    };
  }

  factory TicketHistoryModel.fromMap(Map<String, dynamic> map) {
    return TicketHistoryModel(
      id: map['id'] as int?,
      ticketId: map['ticketId'] as int,
      message: map['message'] as String,
      createdAt: DateFormatter.fromDbString(map['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, ticketId, message, createdAt];
}
