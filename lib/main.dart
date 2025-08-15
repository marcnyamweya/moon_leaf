import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_leaf/screens/browse/bloc/browse_bloc.dart';
import 'package:moon_leaf/screens/browse/browse_screen.dart';    //Move to the routing file eventually
import 'package:moon_leaf/screens/library/library_screen.dart'; //Move to the routing file eventually
import 'package:moon_leaf/services/settings_bloc.dart';
import 'package:moon_leaf/services/settings_service.dart';
import 'package:moon_leaf/services/source_service.dart';
import 'package:moon_leaf/themes/app_theme.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LibraryScreen()),
    // Add more routes here
    GoRoute(path: '/browse', builder: (context, state) => const BrowseScreen()),
  ],
);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BrowseBloc>(
          create: (_) => BrowseBloc(sourceService: SourceService()),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => SettingsBloc(settingsService: SettingsService()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Moon Leaf',
        theme: AppTheme.fromName('Default'),
        darkTheme: AppTheme.fromNameDark('Default'),
        themeMode: ThemeMode.system,
        // routerDelegate: _router.routerDelegate,
        // routeInformationParser: _router.routeInformationParser,
        routerConfig: _router,
      ),
    );
  }
}
