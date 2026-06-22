import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk_ticketing_system/core/helper/app_validator.dart';
import 'package:help_desk_ticketing_system/core/translation/translation_helper.dart';

import '../../../../core/helper/date_formatter.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/shared_components/confirm_dialog.dart';
import '../../../../core/shared_components/custom_button.dart';
import '../../../../core/shared_components/custom_dropdown.dart';
import '../../../../core/shared_components/custom_text_field.dart';
import '../../../../core/shared_components/priority_chip.dart';
import '../../../../core/shared_components/status_chip.dart';

import '../../data/models/enums.dart';
import '../../data/models/ticket_model.dart';
import '../../data/repo/ticket_repository.dart';
import '../cubit/ticket_detail/ticket_detail_cubit.dart';
import '../cubit/ticket_detail/ticket_detail_state.dart';
import '../widgets/comment_tile.dart';

/// Owns the [TicketDetailCubit] lifecycle for this screen — created fresh
/// every time a ticket is opened, disposed when the screen is popped.
class TicketDetailScreen extends StatelessWidget {
  final TicketModel ticket;
  const TicketDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TicketDetailCubit>(
      create: (_) => TicketDetailCubit(
        ticketRepository: getIt.get<TicketRepository>(),
        initialTicket: ticket,
      ),
      child: const _TicketDetailBody(),
    );
  }
}

class _TicketDetailBody extends StatefulWidget {
  const _TicketDetailBody();

  @override
  State<_TicketDetailBody> createState() => _TicketDetailBodyState();
}

class _TicketDetailBodyState extends State<_TicketDetailBody> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _subjectController;
  late TextEditingController _descriptionController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final ticket = context.read<TicketDetailCubit>().state.ticket;
    _subjectController = TextEditingController(text: ticket.subject);
    _descriptionController = TextEditingController(text: ticket.description);
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: context.tr('delete_ticket'),
      message: context.tr('delete_confirmation'),
      confirmLabel: context.tr('delete'),
      cancelLabel: context.tr('cancel'),
    );
    if (confirmed && context.mounted) {
      context.read<TicketDetailCubit>().deleteTicket();
    }
  }

  void _saveEdits(TicketModel current) {
    if (!_formKey.currentState!.validate()) return;
    context.read<TicketDetailCubit>().updateFields(
      subject: _subjectController.text,
      description: _descriptionController.text,
    );
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;

    return BlocConsumer<TicketDetailCubit, TicketDetailState>(
      listener: (context, state) {
        if (state.status == TicketDetailStatus.deleted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.tr('ticket_deleted'))));
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final ticket = state.ticket;
        final isBusy = state.status == TicketDetailStatus.updating;

        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr('ticket_details')),
            actions: [
              IconButton(
                tooltip: context.tr('edit'),
                onPressed: () => setState(() => _isEditing = !_isEditing),
                icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined),
              ),
              IconButton(
                tooltip: context.tr('delete'),
                onPressed: isBusy ? null : () => _confirmDelete(context),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${context.tr('ticket_number')}: ${ticket.ticketNumber}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  StatusChip(status: ticket.status),
                ],
              ),
              const SizedBox(height: 16),

              if (_isEditing) ...[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _subjectController,
                        label: context.tr('subject'),
                        validator: (v) => AppValidators.required(
                          v,
                          fieldLabel: context.tr('subject'),
                          isArabic: isArabic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _descriptionController,
                        label: context.tr('description'),
                        maxLines: 5,
                        validator: (v) => AppValidators.required(
                          v,
                          fieldLabel: context.tr('description'),
                          isArabic: isArabic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown<TicketPriority>(
                        label: context.tr('priority'),
                        value: ticket.priority,
                        items: TicketPriority.values,
                        itemLabel: (p) => p.label(isArabic),
                        onChanged: (p) {
                          if (p != null) {
                            context.read<TicketDetailCubit>().updateFields(
                              priority: p,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        label: context.tr('save'),
                        isLoading: isBusy,
                        onPressed: () => _saveEdits(ticket),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  ticket.subject,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(ticket.description),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriorityChip(priority: ticket.priority),
                    Text(ticket.category.label(isArabic)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${context.tr('created_at')}: ${DateFormatter.toDisplay(ticket.createdAt)}',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${context.tr('updated_at')}: ${DateFormatter.toDisplay(ticket.updatedAt)}',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],

              const Divider(height: 32),

              Text(
                context.tr('change_status'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TicketStatus.values.map((s) {
                  final selected = s == ticket.status;
                  return ChoiceChip(
                    label: Text(s.label(isArabic)),
                    selected: selected,
                    onSelected: isBusy
                        ? null
                        : (_) =>
                              context.read<TicketDetailCubit>().changeStatus(s),
                  );
                }).toList(),
              ),

              const Divider(height: 32),

              Text(
                context.tr('history'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              if (state.history.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    context.tr('no_tickets_found'),
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                )
              else
                ...state.history.map((h) => CommentTile(item: h)),
            ],
          ),
        );
      },
    );
  }
}
