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
import 'package:moon_leaf/services/settings_bloc.dart';

// Placeholder classes for missing functionality
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(theme: AppTheme.fromName('Default'))) {
    on<ThemeEvent>((event, emit) {});
  }
}

class ThemeEvent {}

class ThemeState {
  final ThemeData theme;
  ThemeState({required this.theme});
}

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryState()) {
    on<LibraryEvent>((event, emit) {});
  }
}

class LibraryEvent {}

class LoadLibrary extends LibraryEvent {
  final String searchText;
  LoadLibrary({required this.searchText});
}

class RefetchLibrary extends LibraryEvent {}

class LibraryState {
  final List<LibraryCategory>? library;
  final bool isLoading;
  LibraryState({this.library, this.isLoading = false});
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryState()) {
    on<HistoryEvent>((event, emit) {});
  }
}

class HistoryEvent {}

class LoadHistory extends HistoryEvent {}

class HistoryState {
  final List<dynamic> history;
  final bool isLoading;
  final String? error;
  HistoryState({this.history = const [], this.isLoading = false, this.error});
}

// Extend SettingsState with missing properties
extension SettingsStateExtension on SettingsState {
  bool get downloadedOnlyMode => false; // Placeholder
  bool get incognitoMode => false; // Placeholder
  bool get showNumberOfNovels => false; // Placeholder
  bool get useLibraryFAB => false; // Placeholder
}

// Placeholder utility classes
class Strings {
  static String get(String key) {
    // Return placeholder strings
    switch (key) {
      case 'libraryScreen.searchbar':
        return 'Search library';
      case 'common.searchFor':
        return 'Search for';
      case 'common.globally':
        return 'globally';
      default:
        return key;
    }
  }
}

class NavigationUtils {
  static Map<String, dynamic> getChapterScreenRouteParams(dynamic history) {
    return {'history': history};
  }
}

class ChapterQueries {
  static void markAllChaptersRead(int novelId) {
    // Placeholder implementation
  }
  
  static void markAllChaptersUnread(int novelId) {
    // Placeholder implementation
  }
}

class NovelQueries {
  static void followNovel(int userId, int novelId) {
    // Placeholder implementation
  }
}

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
          final categoryIdList = novel.categoryIds.split(',').map((id) => int.tryParse(id.trim()) ?? 0).where((id) => id != 1).toList();
          categoryIds.add(categoryIdList);
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
      body: BlocBuilder<ThemeBloc, ThemeState>(
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





