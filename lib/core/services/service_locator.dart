import 'package:get_it/get_it.dart';

import '../local_db/database_helper.dart';

final getIt = GetIt.instance;
void setupServiceLocator() {
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}
