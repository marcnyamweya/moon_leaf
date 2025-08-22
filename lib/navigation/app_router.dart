import 'package:go_router/go_router.dart';
import './bottom_navigation_shell.dart';
import 'package:moon_leaf/services/settings_bloc.dart';
import 'package:moon_leaf/screens/library/library_screen.dart';
import 'package:moon_leaf/screens/updates/updates_screen.dart';
import 'package:moon_leaf/screens/history/history_screen.dart';
import 'package:moon_leaf/screens/browse/browse_screen.dart';
import 'package:moon_leaf/screens/more/more_screen.dart';
import 'package:moon_leaf/screens/novel/novel_screen.dart';
import 'package:moon_leaf/screens/reader/reader_screen.dart';

class AppRouter {
  static GoRouter createRouter(SettingsBloc settingsBloc) {
    return GoRouter(
      initialLocation: '/library',
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return BottomNavigationShell(
              child: child,
              settings: settingsBloc,
            );
          },
          routes: [
            // Bottom tab routes
            GoRoute(
              path: '/library',
              name: 'library',
              builder: (context, state) => const LibraryScreen(),
            ),
            GoRoute(
              path: '/updates',
              name: 'updates',
              builder: (context, state) => const UpdatesScreen(),
            ),
            GoRoute(
              path: '/history',
              name: 'history',
              builder: (context, state) => const HistoryScreen(),
            ),
            GoRoute(
              path: '/browse',
              name: 'browse',
              builder: (context, state) => const BrowseScreen(),
            ),
            GoRoute(
              path: '/more',
              name: 'more',
              builder: (context, state) => const MoreScreen(),
            ),
          ],
        ),
        
        // Full-screen routes (outside bottom navigation)
        GoRoute(
          path: '/novel/:novelId',
          name: 'novel',
          builder: (context, state) {
            final novelId = state.pathParameters['novelId']!;
            return NovelScreen(novelId: novelId);
          },
        ),
        
        GoRoute(
          path: '/reader/:chapterId',
          name: 'chapter',
          builder: (context, state) {
            final chapterId = state.pathParameters['chapterId']!;
            return ReaderScreen(chapterId: chapterId);
          },
        ),
        
        // Add other full-screen routes here...
      ],
    );
  }
}