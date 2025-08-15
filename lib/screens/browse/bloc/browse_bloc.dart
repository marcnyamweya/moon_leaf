import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moon_leaf/sources/source_model.dart';
import 'package:moon_leaf/services/source_service.dart';

// Events
abstract class BrowseEvent extends Equatable {
  const BrowseEvent();

  @override
  List<Object?> get props => [];
}

class GetSourcesEvent extends BrowseEvent {
  const GetSourcesEvent();
}

class SearchSourcesEvent extends BrowseEvent {
  final String query;
  
  const SearchSourcesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class TogglePinSourceEvent extends BrowseEvent {
  final int sourceId;
  
  const TogglePinSourceEvent(this.sourceId);

  @override
  List<Object?> get props => [sourceId];
}

class SetLastUsedSourceEvent extends BrowseEvent {
  final int sourceId;
  
  const SetLastUsedSourceEvent(this.sourceId);

  @override
  List<Object?> get props => [sourceId];
}

class UpdateLanguageFiltersEvent extends BrowseEvent {
  final List<String> languageFilters;
  
  const UpdateLanguageFiltersEvent(this.languageFilters);

  @override
  List<Object?> get props => [languageFilters];
}

class RefreshSourcesEvent extends BrowseEvent {
  const RefreshSourcesEvent();
}

// State
class BrowseState extends Equatable {
  final List<Source> allSources;
  final List<Source> searchResults;
  final List<Source> pinnedSources;
  final Set<int> pinnedSourceIds;
  final Source? lastUsedSource;
  final List<String> languageFilters;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final String? currentSearchQuery;

  const BrowseState({
    this.allSources = const [],
    this.searchResults = const [],
    this.pinnedSources = const [],
    this.pinnedSourceIds = const {},
    this.lastUsedSource,
    this.languageFilters = const ['English'],
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.currentSearchQuery,
  });

  BrowseState copyWith({
    List<Source>? allSources,
    List<Source>? searchResults,
    List<Source>? pinnedSources,
    Set<int>? pinnedSourceIds,
    Source? lastUsedSource,
    List<String>? languageFilters,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    String? currentSearchQuery,
  }) {
    return BrowseState(
      allSources: allSources ?? this.allSources,
      searchResults: searchResults ?? this.searchResults,
      pinnedSources: pinnedSources ?? this.pinnedSources,
      pinnedSourceIds: pinnedSourceIds ?? this.pinnedSourceIds,
      lastUsedSource: lastUsedSource ?? this.lastUsedSource,
      languageFilters: languageFilters ?? this.languageFilters,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,
    );
  }

  @override
  List<Object?> get props => [
    allSources,
    searchResults,
    pinnedSources,
    pinnedSourceIds,
    lastUsedSource,
    languageFilters,
    isLoading,
    hasError,
    errorMessage,
    currentSearchQuery,
  ];
}

// Bloc
class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final SourceService _sourceService;
  StreamSubscription<List<Source>>? _sourcesSubscription;

  BrowseBloc({required SourceService sourceService})
      : _sourceService = sourceService,
        super(const BrowseState()) {
    on<GetSourcesEvent>(_onGetSources);
    on<SearchSourcesEvent>(_onSearchSources);
    on<TogglePinSourceEvent>(_onTogglePinSource);
    on<SetLastUsedSourceEvent>(_onSetLastUsedSource);
    on<UpdateLanguageFiltersEvent>(_onUpdateLanguageFilters);
    on<RefreshSourcesEvent>(_onRefreshSources);
  }

  Future<void> _onGetSources(
    GetSourcesEvent event,
    Emitter<BrowseState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, hasError: false, errorMessage: null));
      
      // Load sources from service
      final sources = await _sourceService.getSources();
      
      // Filter sources by language
      final filteredSources = _filterSourcesByLanguage(sources, state.languageFilters);
      
      // Load pinned sources and last used source
      final pinnedSourceIds = await _sourceService.getPinnedSourceIds();
      final pinnedSourceIdsSet = pinnedSourceIds.toSet();
      final pinnedSources = filteredSources.where((s) => pinnedSourceIdsSet.contains(s.sourceId)).toList();
      final lastUsedSource = await _sourceService.getLastUsedSource();
      
      emit(state.copyWith(
        allSources: filteredSources,
        pinnedSources: pinnedSources,
        pinnedSourceIds: pinnedSourceIdsSet,
        lastUsedSource: lastUsedSource,
        searchResults: const [],
        currentSearchQuery: null,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSearchSources(
    SearchSourcesEvent event,
    Emitter<BrowseState> emit,
  ) async {
    try {
      if (event.query.isEmpty) {
        // If search is empty, show all sources
        emit(state.copyWith(
          searchResults: const [],
          currentSearchQuery: null,
        ));
        return;
      }

      emit(state.copyWith(isLoading: true));
      
      // Search through all sources
      final searchResults = state.allSources
          .where((source) =>
              source.sourceName.toLowerCase().contains(event.query.toLowerCase()) ||
              source.url.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(state.copyWith(
        searchResults: searchResults,
        currentSearchQuery: event.query,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onTogglePinSource(
    TogglePinSourceEvent event,
    Emitter<BrowseState> emit,
  ) async {
    try {
      final newPinnedSourceIds = Set<int>.from(state.pinnedSourceIds);
      
      if (newPinnedSourceIds.contains(event.sourceId)) {
        newPinnedSourceIds.remove(event.sourceId);
      } else {
        newPinnedSourceIds.add(event.sourceId);
      }
      
      // Update pinned sources in service
      await _sourceService.setPinnedSourceIds(newPinnedSourceIds.toList());
      
      // Update pinned sources list
      final pinnedSources = state.allSources
          .where((s) => newPinnedSourceIds.contains(s.sourceId))
          .toList();

      emit(state.copyWith(
        pinnedSourceIds: newPinnedSourceIds,
        pinnedSources: pinnedSources,
      ));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSetLastUsedSource(
    SetLastUsedSourceEvent event,
    Emitter<BrowseState> emit,
  ) async {
    try {
      final source = state.allSources.firstWhere(
        (s) => s.sourceId == event.sourceId,
        orElse: () => throw Exception('Source not found'),
      );
      
      // Save last used source to service
      await _sourceService.setLastUsedSource(source);
      
      emit(state.copyWith(lastUsedSource: source));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateLanguageFilters(
    UpdateLanguageFiltersEvent event,
    Emitter<BrowseState> emit,
  ) async {
    try {
      // Filter current sources by new language filters
      final filteredSources = _filterSourcesByLanguage(state.allSources, event.languageFilters);
      
      // Update pinned sources for new filter
      final pinnedSources = filteredSources
          .where((s) => state.pinnedSourceIds.contains(s.sourceId))
          .toList();

      emit(state.copyWith(
        languageFilters: event.languageFilters,
        allSources: filteredSources,
        pinnedSources: pinnedSources,
        searchResults: const [],
        currentSearchQuery: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshSources(
    RefreshSourcesEvent event,
    Emitter<BrowseState> emit,
  ) async {
    // Trigger a fresh load of sources
    add(const GetSourcesEvent());
  }

  List<Source> _filterSourcesByLanguage(List<Source> sources, List<String> languageFilters) {
    if (languageFilters.isEmpty) return sources;
    
    return sources.where((source) => languageFilters.contains(source.lang)).toList();
  }

  @override
  Future<void> close() {
    _sourcesSubscription?.cancel();
    return super.close();
  }
}
