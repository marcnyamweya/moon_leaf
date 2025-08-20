import 'dart:convert';
import 'package:moon_leaf/sources/source_model.dart';

class SourceService {
  // In a real app, this would be replaced with actual database operations
  // For now, we'll use in-memory storage with some mock data
  
  static final SourceService _instance = SourceService._internal();
  factory SourceService() => _instance;
  SourceService._internal();

  // Mock data - in a real app, this would come from a database or API
  final List<Source> _mockSources = [
    Source(
      sourceId: 1,
      sourceName: 'NovelUpdates',
      url: 'https://www.novelupdates.com',
      lang: 'English',
      icon: 'assets/images/novelupdates.png',
      isNsfw: false,
    ),
    Source(
      sourceId: 2,
      sourceName: 'WebNovel',
      url: 'https://www.webnovel.com',
      lang: 'English',
      icon: 'assets/images/webnovel.png',
      isNsfw: false,
    ),
    Source(
      sourceId: 3,
      sourceName: 'Royal Road',
      url: 'https://www.royalroad.com',
      lang: 'English',
      icon: 'assets/images/royalroad.png',
      isNsfw: false,
    ),
    Source(
      sourceId: 4,
      sourceName: 'Scribble Hub',
      url: 'https://www.scribblehub.com',
      lang: 'English',
      icon: 'assets/images/scribblehub.png',
      isNsfw: false,
    ),
    Source(
      sourceId: 5,
      sourceName: 'WuxiaWorld',
      url: 'https://www.wuxiaworld.com',
      lang: 'English',
      icon: 'assets/images/wuxiaworld.png',
      isNsfw: false,
    ),
    Source(
      sourceId: 6,
      sourceName: 'Light Novel Pub',
      url: 'https://www.lightnovelpub.com',
      lang: 'English',
      icon: 'assets/images/lightnovelpub.png',
      isNsfw: false,
    ),
  ];

  // In-memory storage for pinned sources and last used source
  final List<int> _pinnedSourceIds = [];
  Source? _lastUsedSource;

  /// Get all available sources
  Future<List<Source>> getSources() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockSources);
  }

  /// Get pinned source IDs
  Future<List<int>> getPinnedSourceIds() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_pinnedSourceIds);
  }

  /// Set pinned source IDs
  Future<void> setPinnedSourceIds(List<int> sourceIds) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _pinnedSourceIds.clear();
    _pinnedSourceIds.addAll(sourceIds);
  }

  /// Get last used source
  Future<Source?> getLastUsedSource() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _lastUsedSource;
  }

  /// Set last used source
  Future<void> setLastUsedSource(Source source) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _lastUsedSource = source;
  }

  /// Search sources by query
  Future<List<Source>> searchSources(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) return [];
    
    return _mockSources
        .where((source) =>
            source.sourceName.toLowerCase().contains(query.toLowerCase()) ||
            source.url.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Get sources by language
  Future<List<Source>> getSourcesByLanguage(String language) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    return _mockSources
        .where((source) => source.lang.toLowerCase() == language.toLowerCase())
        .toList();
  }

  /// Add a new source (for future use)
  Future<void> addSource(Source source) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockSources.add(source);
  }

  /// Remove a source (for future use)
  Future<void> removeSource(int sourceId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockSources.removeWhere((source) => source.sourceId == sourceId);
  }

  /// Update a source (for future use)
  Future<void> updateSource(Source source) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _mockSources.indexWhere((s) => s.sourceId == source.sourceId);
    if (index != -1) {
      _mockSources[index] = source;
    }
  }

  /// Get available languages
  Future<List<String>> getAvailableLanguages() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockSources
        .map((source) => source.lang)
        .toSet()
        .toList();
  }

  /// Clear all data (for testing/reset purposes)
  Future<void> clearAllData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _pinnedSourceIds.clear();
    _lastUsedSource = null;
  }
}

