import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/translation/translation_helper.dart';

import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/manager/theme_cubit.dart';
import 'core/translation/manager/locale_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LocaleCubit()),
      ],
      child: Builder(
        builder: (context) {
          final themeMode = context.watch<ThemeCubit>().state.themeMode;
          final locale = context.watch<LocaleCubit>().state.locale;
          return MaterialApp(
            title: 'Help Desk',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            locale: locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppTranslations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: AppRoutes.dashboard,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
