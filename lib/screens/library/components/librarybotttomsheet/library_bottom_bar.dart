import 'package:flutter/material.dart';
import 'package:moon_leaf/widgets/BottomSheet/bottom_sheet.dart' as bs;

/// --- Domain models (mirror your RN enums/lists) -----------------------------

enum DisplayMode { comfortable, compact, list }

enum LibraryFilter { all, downloaded, unread }

enum LibrarySortKey { dateAdded, name, lastRead }
enum SortDir { asc, desc }

class LibrarySortOrder {
  final LibrarySortKey key;
  final SortDir dir;
  const LibrarySortOrder(this.key, this.dir);

  LibrarySortOrder toggled() =>
      LibrarySortOrder(key, dir == SortDir.asc ? SortDir.desc : SortDir.asc);
}

class LibrarySettings {
  final LibraryFilter? filter;
  final LibrarySortOrder sortOrder;
  final DisplayMode displayMode;
  final bool showDownloadBadges;
  final bool showUnreadBadges;
  final bool showNumberOfNovels;

  const LibrarySettings({
    this.filter,
    this.sortOrder = const LibrarySortOrder(LibrarySortKey.dateAdded, SortDir.desc),
    this.displayMode = DisplayMode.comfortable,
    this.showDownloadBadges = true,
    this.showUnreadBadges = true,
    this.showNumberOfNovels = false,
  });

  LibrarySettings copyWith({
    LibraryFilter? Function()? filter,
    LibrarySortOrder? sortOrder,
    DisplayMode? displayMode,
    bool? showDownloadBadges,
    bool? showUnreadBadges,
    bool? showNumberOfNovels,
  }) {
    return LibrarySettings(
      filter: filter != null ? filter() : this.filter,
      sortOrder: sortOrder ?? this.sortOrder,
      displayMode: displayMode ?? this.displayMode,
      showDownloadBadges: showDownloadBadges ?? this.showDownloadBadges,
      showUnreadBadges: showUnreadBadges ?? this.showUnreadBadges,
      showNumberOfNovels: showNumberOfNovels ?? this.showNumberOfNovels,
    );
  }
}

/// --- Public API -------------------------------------------------------------

class LibraryBottomBar {
  /// Opens the modal bottom sheet with tabs.
  static Future<void> show(
    BuildContext context, {
    required LibrarySettings initial,
    required ValueChanged<LibrarySettings> onChanged,
    bool downloadedOnlyMode = false,
    bool isDismissible = true,
  }) async {
    bs.BottomSheet.show(
      context,
      isDismissible: isDismissible,
      child: _LibraryBottomBarContent(
        initial: initial,
        onChanged: onChanged,
        downloadedOnlyMode: downloadedOnlyMode,
      ),
    );
  }
}

/// --- UI --------------------------------------------------------------------

class _LibraryBottomBarContent extends StatefulWidget {
  final LibrarySettings initial;
  final ValueChanged<LibrarySettings> onChanged;
  final bool downloadedOnlyMode;
  const _LibraryBottomBarContent({
    required this.initial,
    required this.onChanged,
    required this.downloadedOnlyMode,
  });

  @override
  State<_LibraryBottomBarContent> createState() => _LibraryBottomBarContentState();
}

class _LibraryBottomBarContentState extends State<_LibraryBottomBarContent>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  late LibrarySettings _state;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _state = widget.initial;
  }

  void _update(LibrarySettings next) {
    setState(() => _state = next);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle / grabber
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Tabs
          TabBar(
            controller: _tab,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            tabs: const [
              Tab(text: 'Filter'),
              Tab(text: 'Sort'),
              Tab(text: 'Display'),
            ],
          ),

          // Content
          SizedBox(
            height: 420, // similar to your RN snapPoint ~520; adjust as you like
            child: TabBarView(
              controller: _tab,
              children: [
                _FilterTab(
                  state: _state,
                  downloadedOnlyMode: widget.downloadedOnlyMode,
                  onChanged: _update,
                ),
                _SortTab(
                  state: _state,
                  onChanged: _update,
                ),
                _DisplayTab(
                  state: _state,
                  onChanged: _update,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }
}

/// --- Tabs ------------------------------------------------------------------

class _FilterTab extends StatelessWidget {
  final LibrarySettings state;
  final ValueChanged<LibrarySettings> onChanged;
  final bool downloadedOnlyMode;

  const _FilterTab({
    required this.state,
    required this.onChanged,
    required this.downloadedOnlyMode,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RadioListTile<LibraryFilter?>(
          title: const Text('All'),
          value: null,
          groupValue: state.filter,
          onChanged: (v) => onChanged(state.copyWith(filter: () => v)),
        ),
        RadioListTile<LibraryFilter?>(
          title: const Text('Downloaded'),
          value: LibraryFilter.downloaded,
          groupValue: state.filter,
          onChanged: downloadedOnlyMode ? null : (v) => onChanged(state.copyWith(filter: () => v)),
          secondary: downloadedOnlyMode ? const Icon(Icons.lock) : null,
        ),
        RadioListTile<LibraryFilter?>(
          title: const Text('Unread'),
          value: LibraryFilter.unread,
          groupValue: state.filter,
          onChanged: (v) => onChanged(state.copyWith(filter: () => v)),
        ),
      ],
    );
    }
}

class _SortTab extends StatelessWidget {
  final LibrarySettings state;
  final ValueChanged<LibrarySettings> onChanged;
  const _SortTab({required this.state, required this.onChanged});

  void _setKey(LibrarySortKey key) {
    final dir = (state.sortOrder.key == key) ? state.sortOrder.dir : SortDir.asc;
    onChanged(state.copyWith(sortOrder: LibrarySortOrder(key, dir)));
  }

  void _toggleDir(LibrarySortKey key) {
    if (state.sortOrder.key == key) {
      onChanged(state.copyWith(sortOrder: state.sortOrder.toggled()));
    } else {
      onChanged(state.copyWith(sortOrder: LibrarySortOrder(key, SortDir.asc)));
    }
  }

  Widget _row(BuildContext context, String label, LibrarySortKey key) {
    final selected = state.sortOrder.key == key;
    final dirIcon =
        selected ? (state.sortOrder.dir == SortDir.asc ? Icons.north : Icons.south) : Icons.unfold_more;

    return ListTile(
      title: Text(label),
      leading: Radio<LibrarySortKey>(
        value: key,
        groupValue: state.sortOrder.key,
        onChanged: (_) => _setKey(key),
      ),
      trailing: IconButton(
        icon: Icon(dirIcon),
        onPressed: () => _toggleDir(key),
        tooltip: 'Toggle ASC/DESC',
      ),
      onTap: () => _setKey(key),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _row(context, 'Date added', LibrarySortKey.dateAdded),
        _row(context, 'Name', LibrarySortKey.name),
        _row(context, 'Last read', LibrarySortKey.lastRead),
      ],
    );
  }
}

class _DisplayTab extends StatelessWidget {
  final LibrarySettings state;
  final ValueChanged<LibrarySettings> onChanged;
  const _DisplayTab({required this.state, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text('Badges', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        SwitchListTile(
          title: const Text('Show download badges'),
          value: state.showDownloadBadges,
          onChanged: (v) => onChanged(state.copyWith(showDownloadBadges: v)),
        ),
        SwitchListTile(
          title: const Text('Show unread badges'),
          value: state.showUnreadBadges,
          onChanged: (v) => onChanged(state.copyWith(showUnreadBadges: v)),
        ),
        SwitchListTile(
          title: const Text('Show number of items'),
          value: state.showNumberOfNovels,
          onChanged: (v) => onChanged(state.copyWith(showNumberOfNovels: v)),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text('Display mode', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        RadioListTile<DisplayMode>(
          title: const Text('Comfortable'),
          value: DisplayMode.comfortable,
          groupValue: state.displayMode,
          onChanged: (v) => onChanged(state.copyWith(displayMode: v)),
        ),
        RadioListTile<DisplayMode>(
          title: const Text('Compact'),
          value: DisplayMode.compact,
          groupValue: state.displayMode,
          onChanged: (v) => onChanged(state.copyWith(displayMode: v)),
        ),
        RadioListTile<DisplayMode>(
          title: const Text('List'),
          value: DisplayMode.list,
          groupValue: state.displayMode,
          onChanged: (v) => onChanged(state.copyWith(displayMode: v)),
        ),
      ],
    );
  }
}
