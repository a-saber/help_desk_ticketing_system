import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk_ticketing_system/core/helper/app_validator.dart';
import 'package:help_desk_ticketing_system/core/services/service_locator.dart';
import 'package:help_desk_ticketing_system/core/translation/translation_helper.dart';

import '../../../../core/shared_components/custom_button.dart';
import '../../../../core/shared_components/custom_dropdown.dart';
import '../../../../core/shared_components/custom_text_field.dart';
import '../../data/models/enums.dart';
import '../../data/repo/ticket_repository.dart';
import '../cubit/ticket_form/ticket_form_cubit.dart';
import '../cubit/ticket_form/ticket_form_state.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit(context) {
    if (!_formKey.currentState!.validate()) return;
    TicketFormCubit.get(context).submit(
      subject: _subjectController.text,
      description: _descriptionController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('create_ticket'))),
      body: BlocProvider(
        create: (_) =>
            TicketFormCubit(ticketRepository: getIt.get<TicketRepository>()),
        child: BlocConsumer<TicketFormCubit, TicketFormState>(
          listener: (context, state) {
            if (state.status == TicketFormStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.tr('ticket_created'))),
              );
              Navigator.pop(context);
            } else if (state.status == TicketFormStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? context.tr('export_failed'),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
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
                    value: state.priority,
                    items: TicketPriority.values,
                    itemLabel: (p) => p.label(isArabic),
                    onChanged: (p) {
                      if (p != null) {
                        context.read<TicketFormCubit>().changePriority(p);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomDropdown<TicketCategory>(
                    label: context.tr('category'),
                    value: state.category,
                    items: TicketCategory.values,
                    itemLabel: (c) => c.label(isArabic),
                    onChanged: (c) {
                      if (c != null) {
                        context.read<TicketFormCubit>().changeCategory(c);
                      }
                    },
                  ),
                  const SizedBox(height: 28),
                  CustomButton(
                    label: context.tr('save'),
                    isLoading: state.status == TicketFormStatus.submitting,
                    onPressed: () => _submit(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
