import 'package:flutter/material.dart';

import '../../features/tickets/data/models/ticket_model.dart';
import '../../features/tickets/presentation/views/create_ticket_screen.dart';
import '../../features/tickets/presentation/views/ticket_detail_screen.dart';
import '../../features/tickets/presentation/views/ticket_list_screen.dart';
import 'app_router.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.ticketList:
        return MaterialPageRoute(builder: (_) => const TicketListScreen());
      case AppRoutes.createTicket:
        return MaterialPageRoute(builder: (_) => const CreateTicketScreen());
      case AppRoutes.ticketDetail:
        final ticket = settings.arguments as TicketModel;
        return MaterialPageRoute(
          builder: (_) => TicketDetailScreen(ticket: ticket),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
