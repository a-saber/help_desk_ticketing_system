import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk_ticketing_system/core/translation/translation_helper.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/shared_components/empty_state_widget.dart';
import '../../../../core/shared_components/loading_widget.dart';
import '../cubit/ticket_list/ticket_list_cubit.dart';
import '../cubit/ticket_list/ticket_list_state.dart';
import '../widgets/ticket_card.dart';
import '../widgets/ticket_filter_bar.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TicketListCubit>().loadTickets();
  }

  Future<void> _export() async {
    final cubit = context.read<TicketListCubit>();
    try {
      final path = await cubit.exportToJson();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.tr('export_success')}\n$path')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.tr('export_failed'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('tickets')),
        actions: [
          IconButton(
            tooltip: context.tr('export_json'),
            onPressed: _export,
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: BlocBuilder<TicketListCubit, TicketListState>(
        builder: (context, state) {
          if (state.status == TicketListStatus.loading) {
            return const LoadingWidget();
          }

          final tickets = state.visibleTickets;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TicketFilterBar(
                  statusFilter: state.statusFilter,
                  sortOrder: state.sortOrder,
                  onSearchChanged: (q) =>
                      context.read<TicketListCubit>().search(q),
                  onStatusChanged: (s) =>
                      context.read<TicketListCubit>().filterByStatus(s),
                  onSortChanged: (o) =>
                      context.read<TicketListCubit>().changeSortOrder(o),
                ),
              ),
              Expanded(
                child: tickets.isEmpty
                    ? EmptyStateWidget(
                        title: context.tr('no_tickets_found'),
                        subtitle: context.tr('create_first_ticket'),
                        icon: Icons.confirmation_number_outlined,
                      )
                    : RefreshIndicator(
                        onRefresh: () =>
                            context.read<TicketListCubit>().loadTickets(),
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: tickets.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final ticket = tickets[index];
                            return TicketCard(
                              ticket: ticket,
                              onTap: () async {
                                await Navigator.pushNamed(
                                  context,
                                  AppRoutes.ticketDetail,
                                  arguments: ticket,
                                );
                                if (context.mounted) {
                                  context.read<TicketListCubit>().loadTickets();
                                }
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.createTicket);
          if (context.mounted) context.read<TicketListCubit>().loadTickets();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
