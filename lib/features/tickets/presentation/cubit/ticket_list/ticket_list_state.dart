import 'package:equatable/equatable.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/ticket_model.dart';

enum TicketListStatus { initial, loading, loaded, error }

class TicketListState extends Equatable {
  final TicketListStatus status;
  final List<TicketModel> allTickets;
  final String searchQuery;
  final TicketStatus? statusFilter;
  final SortOrder sortOrder;
  final String? errorMessage;

  const TicketListState({
    this.status = TicketListStatus.initial,
    this.allTickets = const [],
    this.searchQuery = '',
    this.statusFilter,
    this.sortOrder = SortOrder.newestFirst,
    this.errorMessage,
  });

  /// Derived, filtered+sorted view. Kept as a getter (not stored) so there
  /// is exactly one source of truth (`allTickets`) and no risk of the
  /// filtered list going stale relative to it.
  List<TicketModel> get visibleTickets {
    var result = allTickets.where((t) {
      final matchesSearch =
          searchQuery.isEmpty ||
          t.subject.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = statusFilter == null || t.status == statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();

    result.sort(
      (a, b) => sortOrder == SortOrder.newestFirst
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt),
    );

    return result;
  }

  TicketListState copyWith({
    TicketListStatus? status,
    List<TicketModel>? allTickets,
    String? searchQuery,
    TicketStatus? statusFilter,
    bool clearStatusFilter = false,
    SortOrder? sortOrder,
    String? errorMessage,
  }) {
    return TicketListState(
      status: status ?? this.status,
      allTickets: allTickets ?? this.allTickets,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter
          ? null
          : (statusFilter ?? this.statusFilter),
      sortOrder: sortOrder ?? this.sortOrder,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allTickets,
    searchQuery,
    statusFilter,
    sortOrder,
    errorMessage,
  ];
}
