// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// // import 'package:moon_leaf/screens/browse/browse_screen.dart';

// // final _router = GoRouter(
// //   routes: [
// //     GoRoute(path: '/browse', builder: (context, state) => const BrowseScreen()),
// //     // Add more routes here
// //   ],
// // );
// class LibraryScreen extends StatelessWidget {
//   const LibraryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Library'),
//       ),
//       body:  Center(
//         child: ElevatedButton(
//           onPressed: () {
//             context.go('/browse');
//           },
//           child: const Text('Library Screen'),
//         ),
//       ),
//     );
//   }
// }


// lib/screens/library/library_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:moon_leaf/themes/app_theme.dart';
import 'package:moon_leaf/database/novel_info.dart';

import 'package:moon_leaf/widgets/Searchbar/search_bar.dart';
import 'package:moon_leaf/widgets/button/button.dart';
import 'package:moon_leaf/widgets/Actionbar/action_bar.dart';
import 'components/librarybotttomsheet/library_bottom_bar.dart';
import 'package:moon_leaf/screens/novel/components/set_categories_modal.dart';
import './components/library_list_view.dart';
import './components/banner.dart';
// import '../../components/common/row.dart';
// import './blocs/library_bloc.dart';
// import './blocs/library_state.dart';
// import './blocs/library_event.dart';
// import '../../blocs/theme_bloc.dart';
// import '../../blocs/search_bloc.dart';
// import '../../blocs/settings_bloc.dart';
// import '../../blocs/history_bloc.dart';
// import '../../database/queries/chapter_queries.dart';
// import '../../database/queries/novel_queries.dart';
// import '../../utils/navigation_utils.dart';
// import '../../utils/strings.dart';
// import '../novel/components/set_categories_modal.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  List<int> selectedNovelIds = [];
  bool setCategoryModalVisible = false;
  String searchText = '';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    
    // Initialize blocs
    context.read<LibraryBloc>().add(LoadLibrary(searchText: ''));
    context.read<HistoryBloc>().add(LoadHistory());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      searchText = text;
    });
    // Debounce search
    Future.delayed(const Duration(milliseconds: 100), () {
      if (text == searchText) {
        context.read<LibraryBloc>().add(LoadLibrary(searchText: text));
      }
    });
  }

  void _clearSearchbar() {
    _searchController.clear();
    setState(() {
      searchText = '';
    });
    context.read<LibraryBloc>().add(LoadLibrary(searchText: ''));
  }

  void _showBottomSheet() {
    LibraryBottomBar.show(
      context,
      initial: LibrarySettings(),
      onChanged: (settings) {
        // Handle settings change
      },
    );
  }

  void _showSetCategoryModal() {
    setState(() {
      setCategoryModalVisible = true;
    });
  }

  void _closeSetCategoryModal() {
    setState(() {
      setCategoryModalVisible = false;
    });
  }

  void _markAllChaptersRead() {
    for (int id in selectedNovelIds) {
      ChapterQueries.markAllChaptersRead(id);
    }
    setState(() {
      selectedNovelIds = [];
    });
    context.read<LibraryBloc>().add(RefetchLibrary());
  }

  void _markAllChaptersUnread() {
    for (int id in selectedNovelIds) {
      ChapterQueries.markAllChaptersUnread(id);
    }
    setState(() {
      selectedNovelIds = [];
    });
    context.read<LibraryBloc>().add(RefetchLibrary());
  }

  void _deleteSelectedNovels() {
    for (int id in selectedNovelIds) {
      NovelQueries.followNovel(1, id);
    }
    setState(() {
      selectedNovelIds = [];
    });
  }

  void _selectAllNovels(List<LibraryNovelInfo> novels) {
    setState(() {
      selectedNovelIds = novels.map((novel) => novel.novelId).toList();
    });
  }

  List<int> _getSelectedNovelCategoryIds(List<LibraryCategory> library) {
    List<List<int>> categoryIds = [];

    for (var category in library) {
      for (var novel in category.novels) {
        if (selectedNovelIds.contains(novel.novelId)) {
          categoryIds.add(novel.categoryIds.where((id) => id != 1).toList());
        }
      }
    }

    if (categoryIds.isEmpty) return [];
    
    // Find intersection of all category ID lists
    return categoryIds.reduce((a, b) => a.where(b.contains).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: MultiBlocBuilder(
        builders: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  return BlocBuilder<LibraryBloc, LibraryState>(
                    builder: (context, libraryState) {
                      return BlocBuilder<HistoryBloc, HistoryState>(
                        builder: (context, historyState) {
                          return _buildContent(
                            themeState,
                            settingsState,
                            libraryState,
                            historyState,
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    ThemeState themeState,
    SettingsState settingsState,
    LibraryState libraryState,
    HistoryState historyState,
  ) {
    final theme = themeState.theme;
    final library = libraryState.library ?? [];
    
    // Update tab controller length when library changes
    if (_tabController.length != library.length && library.isNotEmpty) {
      _tabController.dispose();
      _tabController = TabController(length: library.length, vsync: this);
    }

    return Column(
      children: [
        Searchbar(
          initialText: searchText,
          placeholder: selectedNovelIds.isEmpty
              ? Strings.get('libraryScreen.searchbar')
              : '${selectedNovelIds.length} selected',
          onChanged: _onSearchTextChanged,
          leftIcon: selectedNovelIds.isNotEmpty 
              ? Icons.close 
              : Icons.search,
          onLeftIconPress: () {
            if (selectedNovelIds.isNotEmpty) {
              setState(() {
                selectedNovelIds = [];
              });
            }
          },
          rightIcons: [
            RightIcon(
              iconData: selectedNovelIds.isNotEmpty
                  ? Icons.select_all
                  : Icons.filter_list,
              onPress: selectedNovelIds.isNotEmpty
                  ? () => _selectAllNovels(
                      library.isNotEmpty 
                          ? library[_tabController.index].novels 
                          : [])
                  : _showBottomSheet,
            ),
          ],
        ),
        
        // Banners
        if (settingsState.downloadedOnlyMode)
          BannerWidget(
            icon: Icons.cloud_off_outlined,
            label: 'Downloaded Only',
          ),
        
        if (settingsState.incognitoMode)
          BannerWidget(
            icon: Icons.privacy_tip_outlined,
            label: 'Incognito Mode',
            backgroundColor: theme.colorScheme.tertiary,
            textColor: theme.colorScheme.onTertiary,
          ),

        // Tab View
        Expanded(
          child: library.isEmpty
              ? _buildLoadingState(libraryState.isLoading)
              : DefaultTabController(
                  length: library.length,
                  child: Column(
                    children: [
                      _buildTabBar(library, theme, settingsState),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: library.map((category) {
                            return _buildTabContent(
                              category,
                              libraryState.isLoading,
                              theme,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return const Center(child: Text('No library data'));
  }

  Widget _buildTabBar(
    List<LibraryCategory> library,
    ThemeData theme,
    SettingsState settingsState,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.12)
                : Colors.black.withOpacity(0.12),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: theme.colorScheme.primary,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.secondary,
        tabs: library.map((category) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(category.name),
                if (settingsState.showNumberOfNovels)
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      '${category.novels.length}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(
    LibraryCategory category,
    bool isLoading,
    ThemeData theme,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Global search button
        if (searchText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButton(
              title: '${Strings.get('common.searchFor')} "$searchText" ${Strings.get('common.globally')}',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/global-search',
                  arguments: {'searchText': searchText},
                );
              },
            ),
          ),
        
        // Library view
        Expanded(
          child: LibraryView(
            categoryId: category.id,
            novels: category.novels,
            selectedNovelIds: selectedNovelIds,
            setSelectedNovelIds: (ids) {
              setState(() {
                selectedNovelIds = ids;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFAB(HistoryState historyState, ThemeData theme) {
    if (!context.read<SettingsBloc>().state.useLibraryFAB ||
        historyState.isLoading ||
        historyState.history.isEmpty ||
        historyState.error != null) {
      return const SizedBox();
    }

    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton.extended(
        onPressed: () {
          final history = historyState.history.first;
          Navigator.pushNamed(
            context,
            '/chapter',
            arguments: NavigationUtils.getChapterScreenRouteParams(history),
          );
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Resume'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildModals(List<LibraryCategory> library) {
    return Stack(
      children: [
        if (setCategoryModalVisible)
          SetCategoryModal(
            novelId: selectedNovelIds,
            currentCategoryIds: _getSelectedNovelCategoryIds(library),
            onSuccess: () {
              setState(() {
                selectedNovelIds = [];
              });
              context.read<LibraryBloc>().add(RefetchLibrary());
              _closeSetCategoryModal();
            },
          ),
      ],
    );
  }
}

// Placeholder classes - implement these according to your needs

class LibraryCategory {
  final int id;
  final String name;
  final List<NovelInfo> novels;

  LibraryCategory({
    required this.id,
    required this.name,
    required this.novels,
  });
}




// Add this to handle multiple BlocBuilders
class MultiBlocBuilder extends StatelessWidget {
  final List<Widget Function(BuildContext)> builders;

  const MultiBlocBuilder({Key? key, required this.builders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builders.first(context);
  }
}