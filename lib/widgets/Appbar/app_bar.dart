import 'package:flutter/material.dart';
import 'package:moon_leaf/themes/themes.dart';




enum AppBarMode {
  small,
  medium,
  large,
  centerAligned,
}

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? handleGoBack;
  final AppBarMode mode;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool showSearchButton;
  final VoidCallback? onSearchPressed;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;
  final Widget? flexibleSpace;
  final double? collapsedHeight;
  final double? expandedHeight;
  final bool floating;
  final bool pinned;
  final bool snap;

  const Appbar({
    super.key,
    required this.title,
    this.handleGoBack,
    this.mode = AppBarMode.large,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.showSearchButton = false,
    this.onSearchPressed,
    this.showMenuButton = false,
    this.onMenuPressed,
    this.flexibleSpace,
    this.collapsedHeight,
    this.expandedHeight,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
  });

  @override
  State<Appbar> createState() => _AppbarState();

  @override
  Size get preferredSize {
    final height = collapsedHeight ?? 
      (mode == AppBarMode.large ? 152.0 : kToolbarHeight);
    return Size.fromHeight(height);
  }
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final effectiveBackgroundColor = widget.backgroundColor ?? colorScheme.surface;
    final effectiveForegroundColor = widget.foregroundColor ?? colorScheme.onSurface;

    List<Widget> appBarActions = [];
    
    // Add search button if enabled
    if (widget.showSearchButton) {
      appBarActions.add(
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: widget.onSearchPressed,
        ),
      );
    }
    
    // Add menu button if enabled
    if (widget.showMenuButton) {
      appBarActions.add(
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: widget.onMenuPressed ?? () => _showAppBarMenu(context),
        ),
      );
    }
    
    // Add custom actions
    if (widget.actions != null) {
      appBarActions.addAll(widget.actions!);
    }

    if (widget.mode == AppBarMode.large || widget.mode == AppBarMode.medium) {
      return SliverAppBar(
        leading: _buildLeading(effectiveForegroundColor),
        actions: appBarActions,
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        expandedHeight: widget.expandedHeight ?? 
          (widget.mode == AppBarMode.large ? 152.0 : 112.0),
        floating: widget.floating,
        pinned: widget.pinned,
        snap: widget.snap,
        flexibleSpace: widget.flexibleSpace ?? FlexibleSpaceBar(
          title: Text(
            widget.title,
            style: TextStyle(color: effectiveForegroundColor),
          ),
          titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
          expandedTitleScale: widget.mode == AppBarMode.large ? 1.5 : 1.2,
        ),
      );
    }

    return AppBar(
      title: Text(widget.title),
      leading: _buildLeading(effectiveForegroundColor),
      actions: appBarActions,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      centerTitle: widget.mode == AppBarMode.centerAligned,
    );
  }

  Widget? _buildLeading(Color foregroundColor) {
    if (widget.handleGoBack != null) {
      return IconButton(
        icon: Icon(Icons.arrow_back, color: foregroundColor),
        onPressed: widget.handleGoBack,
      );
    }
    return null;
  }

  void _showAppBarMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}