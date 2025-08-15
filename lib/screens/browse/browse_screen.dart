import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:moon_leaf/sources/source_model.dart';
import 'package:moon_leaf/screens/browse/bloc/browse_bloc.dart';
import 'package:moon_leaf/services/settings_bloc.dart';
import 'package:moon_leaf/services/settings_service.dart';
import 'components/source_card.dart';
import 'package:moon_leaf/widgets/Emptyview/empty_view.dart';
import 'package:moon_leaf/widgets/ErrorViewV2/error_screen_v2.dart';
import 'package:moon_leaf/widgets/Searchbar/search_bar.dart';
import 'package:moon_leaf/widgets/LoadingScreen/loading_screen.dart';
import 'package:moon_leaf/widgets/tracker_card.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    // Initialize sources on screen load
    context.read<BrowseBloc>().add(const GetSourcesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    setState(() {
      _searchText = text;
    });
    
    if (text.isEmpty) {
      context.read<BrowseBloc>().add(const GetSourcesEvent());
    } else {
      context.read<BrowseBloc>().add(SearchSourcesEvent(text));
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchText = '';
    });
    context.read<BrowseBloc>().add(const GetSourcesEvent());
  }

  void _navigateToSource(Source source, {bool showLatestNovels = false}) {
    // Set last used source
    context.read<BrowseBloc>().add(SetLastUsedSourceEvent(source.sourceId));
    
    // Navigate to source screen
    context.push('/source', extra: {
      'sourceId': source.sourceId,
      'sourceName': source.sourceName,
      'url': source.url,
      'showLatestNovels': showLatestNovels,
    });
  }

  void _togglePinSource(int sourceId) {
    context.read<BrowseBloc>().add(TogglePinSourceEvent(sourceId));
  }

  List<Widget> _buildSearchActions() {
    return [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => context.push('/global-search'),
        tooltip: 'Global Search',
      ),
      IconButton(
        icon: const Icon(Icons.swap_vert),
        onPressed: () => context.push('/migration'),
        tooltip: 'Migration',
      ),
      IconButton(
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => context.push('/browse-settings'),
        tooltip: 'Browse Settings',
      ),
    ];
  }

  Widget _buildDiscoverSection(BrowseSettings settings, ThemeData theme) {
    if (!settings.showMyAnimeList && !settings.showAniList) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Discover',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        if (settings.showAniList)
          TrackerCard(
            trackerName: 'AniList',
            iconAsset: 'assets/images/anilist.png',
            onTap: () => context.push('/browse-anilist'),
          ),
        if (settings.showMyAnimeList)
          TrackerCard(
            trackerName: 'MyAnimeList',
            iconAsset: 'assets/images/mal.png',
            onTap: () => context.push('/browse-mal'),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Text(
        title,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  List<Widget> _buildSourceSections(
    BrowseState state,
    BrowseSettings settings,
    ThemeData theme,
  ) {
    final sections = <Widget>[];

    // Last Used Section
    if (state.lastUsedSource != null) {
      sections.add(_buildSectionHeader('Last Used', theme));
      sections.add(
        SourceCard(
          source: state.lastUsedSource!,
          isPinned: state.pinnedSourceIds.contains(state.lastUsedSource!.sourceId),
          onNavigateToSource: () => _navigateToSource(state.lastUsedSource!),
          onNavigateToLatest: () => _navigateToSource(state.lastUsedSource!, showLatestNovels: true),
          onTogglePinSource: () => _togglePinSource(state.lastUsedSource!.sourceId),
        ),
      );
    }

    // Pinned Sources Section
    if (state.pinnedSources.isNotEmpty) {
      sections.add(_buildSectionHeader('Pinned', theme));
      sections.addAll(
        state.pinnedSources.map(
          (source) => SourceCard(
            source: source,
            isPinned: true,
            onNavigateToSource: () => _navigateToSource(source),
            onNavigateToLatest: () => _navigateToSource(source, showLatestNovels: true),
            onTogglePinSource: () => _togglePinSource(source.sourceId),
          ),
        ),
      );
    }

    // Search Results or All Sources Section
    if (!settings.onlyShowPinnedSources) {
      if (_searchText.isNotEmpty) {
        // Search Results
        sections.add(_buildSectionHeader('Search Results', theme));
        if (state.searchResults.isEmpty) {
          sections.add(
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No results found'),
            ),
          );
        } else {
          sections.addAll(
            state.searchResults.map(
              (source) => SourceCard(
                source: source,
                isPinned: state.pinnedSourceIds.contains(source.sourceId),
                onNavigateToSource: () => _navigateToSource(source),
                onNavigateToLatest: () => _navigateToSource(source, showLatestNovels: true),
                onTogglePinSource: () => _togglePinSource(source.sourceId),
              ),
            ),
          );
        }
      } else {
        // All Sources
        sections.add(_buildSectionHeader('All', theme));
        sections.addAll(
          state.allSources.map(
            (source) => SourceCard(
              source: source,
              isPinned: state.pinnedSourceIds.contains(source.sourceId),
              onNavigateToSource: () => _navigateToSource(source),
              onNavigateToLatest: () => _navigateToSource(source, showLatestNovels: true),
              onTogglePinSource: () => _togglePinSource(source.sourceId),
            ),
          ),
        );
      }
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Searchbar(
          leftIcon: Icons.search,
          placeholder: 'Search sources',
          onChanged: _onSearchChanged,
          rightIcons: [
            RightIcon(
              iconData: Icons.clear,
              onPress: _clearSearch,
            ),
          ],
        ),
        actions: _buildSearchActions(),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: BlocBuilder<BrowseBloc, BrowseState>(
        builder: (context, browseState) {
          return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              final browseSettings = settingsState.browseSettings;

              // Handle loading state
              if (browseState.isLoading && browseState.allSources.isEmpty) {
                return const LoadingScreen();
              }

              // Handle error state
              if (browseState.hasError && browseState.allSources.isEmpty) {
                return ErrorScreen(
                  error: browseState.errorMessage ?? 'Unknown error occurred',
                  actions: [
                    ErrorAction(
                      iconData: Icons.refresh,
                      title: 'Retry',
                      onPressed: () => context.read<BrowseBloc>().add(const GetSourcesEvent()),
                    ),
                  ],
                );
              }

              // Handle empty language filters
              if (browseState.languageFilters.isEmpty) {
                return EmptyView(
                  iconText: '(･Д･。',
                  description: 'No language filters selected',
                  onAction: () => context.push('/browse-settings'),
                  actionText: 'Settings',
                );
              }

              // Handle empty sources
              if (browseState.allSources.isEmpty) {
                return const EmptyView(
                  iconText: '(･Д･。',
                  description: 'No sources available',
                );
              }

              return CustomScrollView(
                slivers: [
                  // Discover Section
                  SliverToBoxAdapter(
                    child: _buildDiscoverSection(browseSettings, theme),
                  ),
                  
                  // Source Sections
                  SliverList(
                    delegate: SliverChildListDelegate(
                      _buildSourceSections(browseState, browseSettings, theme),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

