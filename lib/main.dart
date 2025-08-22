import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_leaf/navigation/app_router.dart';
import 'package:moon_leaf/providers/settings_provider.dart' as settings_provider;
import 'package:moon_leaf/services/settings_bloc.dart' as svc_settings;
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
    final settingsBloc = settings_provider.SettingsBloc();

    final appRouter = AppRouter.createRouter(settingsBloc);

    return MultiBlocProvider(
      providers: [
        BlocProvider<BrowseBloc>(
          create: (_) => BrowseBloc(sourceService: SourceService()),
        ),
        // Provide settings bloc for navigation shell (providers version)
        BlocProvider<settings_provider.SettingsBloc>.value(value: settingsBloc),
        // Provide settings bloc used by LibraryScreen (services version)
        BlocProvider<svc_settings.SettingsBloc>(
          create: (_) => svc_settings.SettingsBloc(settingsService: SettingsService()),
        ),
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
      child: MaterialApp.router(
        title: 'Moon Leaf',
        theme: AppTheme.fromName('Default'),
        darkTheme: AppTheme.fromNameDark('Default'),
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
