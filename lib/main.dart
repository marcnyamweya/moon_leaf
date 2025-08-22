import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_leaf/navigation/app_router.dart';
import 'package:moon_leaf/services/settings_bloc.dart';
import 'package:moon_leaf/screens/library/library_screen.dart';
import 'package:moon_leaf/screens/browse/bloc/browse_bloc.dart';
import 'package:moon_leaf/services/source_service.dart';
import 'package:moon_leaf/services/settings_service.dart';
import 'package:moon_leaf/themes/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create shared blocs that are needed to build the router
    final settingsBloc = SettingsBloc(settingsService: SettingsService())..add(const LoadSettingsEvent());

    final appRouter = AppRouter.createRouter(settingsBloc);

    return MultiBlocProvider(
      providers: [
        BlocProvider<BrowseBloc>(
          create: (_) => BrowseBloc(sourceService: SourceService()),
        ),
        BlocProvider<SettingsBloc>.value(value: settingsBloc),
        // Provide placeholder blocs used by LibraryScreen
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
        BlocProvider<LibraryBloc>(
          create: (_) => LibraryBloc(),
        ),
        BlocProvider<HistoryBloc>(
          create: (_) => HistoryBloc(),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        bloc: settingsBloc,
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Moon Leaf',
            theme: AppTheme.fromName('Default'),
            darkTheme: AppTheme.fromNameDark('Default'),
            themeMode: state.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
