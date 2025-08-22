import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_leaf/providers/settings_provider.dart';

class BottomNavigationShell extends StatefulWidget {
  final Widget child;
  final SettingsBloc settings;

  const BottomNavigationShell({
    super.key,
    required this.child,
    required this.settings,
  });

  @override
  State<BottomNavigationShell> createState() => _BottomNavigationShellState();
}

class _BottomNavigationShellState extends State<BottomNavigationShell> {
  int _currentIndex = 0;

  List<NavigationTab> _getTabs(SettingsState settingsState) {
    List<NavigationTab> tabs = [
      NavigationTab(
        route: '/library',
        icon: Icons.library_books,
        label: 'Library',
      ),
    ];

    // Access settings from the state properly
    final showUpdatesTab = settingsState.settings['showUpdatesTab'] as bool? ?? true;
    final showHistoryTab = settingsState.settings['showHistoryTab'] as bool? ?? true;

    if (showUpdatesTab) {
      tabs.add(NavigationTab(
        route: '/updates',
        icon: Icons.notifications_outlined,
        label: 'Updates',
      ));
    }

    if (showHistoryTab) {
      tabs.add(NavigationTab(
        route: '/history',
        icon: Icons.history,
        label: 'History',
      ));
    }

    tabs.addAll([
      NavigationTab(
        route: '/browse',
        icon: Icons.explore_outlined,
        label: 'Browse',
      ),
      NavigationTab(
        route: '/more',
        icon: Icons.more_horiz,
        label: 'More',
      ),
    ]);

    return tabs;
  }

  void _updateCurrentIndex(String location) {
    final tabs = _getTabs(widget.settings.state);
    final index = tabs.indexWhere((tab) => tab.route == location);
    if (index != -1 && index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update current index based on current location
    final location = GoRouterState.of(context).uri.path;
    _updateCurrentIndex(location);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: widget.settings,
      builder: (context, settingsState) {
        final tabs = _getTabs(settingsState);
        final theme = Theme.of(context);
        final showLabelsInNav = settingsState.settings['showLabelsInNav'] as bool? ?? false;

        return Scaffold(
          body: widget.child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              if (index < tabs.length) {
                setState(() {
                  _currentIndex = index;
                });
                context.go(tabs[index].route);
              }
            },
            destinations: tabs.map((tab) {
              return NavigationDestination(
                icon: Icon(tab.icon),
                label: showLabelsInNav ? tab.label : '',
              );
            }).toList(),
            backgroundColor: theme.colorScheme.surface,
          ),
        );
      },
    );
  }
}

class NavigationTab {
  final String route;
  final IconData icon;
  final String label;

  NavigationTab({
    required this.route,
    required this.icon,
    required this.label,
  });
}