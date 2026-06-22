import 'package:equatable/equatable.dart';

import '../../../../core/helper/date_formatter.dart';
import 'enums.dart';

class TicketModel extends Equatable {
  final int? id;
  final String ticketNumber;
  final String subject;
  final String description;
  final TicketPriority priority;
  final TicketCategory category;
  final TicketStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TicketModel({
    this.id,
    required this.ticketNumber,
    required this.subject,
    required this.description,
    required this.priority,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  TicketModel copyWith({
    String? subject,
    String? description,
    TicketPriority? priority,
    TicketCategory? category,
    TicketStatus? status,
    DateTime? updatedAt,
  }) {
    return TicketModel(
      id: id,
      ticketNumber: ticketNumber,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'ticketNumber': ticketNumber,
      'subject': subject,
      'description': description,
      'priority': priority.dbValue,
      'category': category.dbValue,
      'status': status.dbValue,
      'createdAt': DateFormatter.toDbString(createdAt),
      'updatedAt': DateFormatter.toDbString(updatedAt),
    };
  }

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'] as int?,
      ticketNumber: map['ticketNumber'] as String,
      subject: map['subject'] as String,
      description: map['description'] as String,
      priority: TicketPriorityX.fromDb(map['priority'] as String),
      category: TicketCategoryX.fromDb(map['category'] as String),
      status: TicketStatusX.fromDb(map['status'] as String),
      createdAt: DateFormatter.fromDbString(map['createdAt'] as String),
      updatedAt: DateFormatter.fromDbString(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ticketNumber': ticketNumber,
    'subject': subject,
    'description': description,
    'priority': priority.dbValue,
    'category': category.dbValue,
    'status': status.dbValue,
    'createdAt': DateFormatter.toDbString(createdAt),
    'updatedAt': DateFormatter.toDbString(updatedAt),
  };

  @override
  List<Object?> get props => [
    id,
    ticketNumber,
    subject,
    description,
    priority,
    category,
    status,
    createdAt,
    updatedAt,
  ];
}
