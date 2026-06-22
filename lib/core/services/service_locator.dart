import 'package:get_it/get_it.dart';

import '../../features/tickets/data/data_sources/ticket_local_datasource.dart';
import '../../features/tickets/data/repo/ticket_repository.dart';
import '../../features/tickets/data/repo/ticket_repository_impl.dart';
import '../local_db/database_helper.dart';

final getIt = GetIt.instance;
void setupServiceLocator() {
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  getIt.registerLazySingleton<TicketLocalDataSource>(
    () =>
        TicketLocalDataSourceImpl(databaseHelper: getIt.get<DatabaseHelper>()),
  );
  getIt.registerLazySingleton<TicketRepository>(
    () => TicketRepositoryImpl(
      localDataSource: getIt.get<TicketLocalDataSource>(),
    ),
  );
}
