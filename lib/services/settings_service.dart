import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrowseSettings {
  final bool showMyAnimeList;
  final bool showAniList;
  final bool onlyShowPinnedSources;
  final bool searchAllSources;

  const BrowseSettings({
    this.showMyAnimeList = true,
    this.showAniList = true,
    this.onlyShowPinnedSources = false,
    this.searchAllSources = false,
  });

  BrowseSettings copyWith({
    bool? showMyAnimeList,
    bool? showAniList,
    bool? onlyShowPinnedSources,
    bool? searchAllSources,
  }) {
    return BrowseSettings(
      showMyAnimeList: showMyAnimeList ?? this.showMyAnimeList,
      showAniList: showAniList ?? this.showAniList,
      onlyShowPinnedSources: onlyShowPinnedSources ?? this.onlyShowPinnedSources,
      searchAllSources: searchAllSources ?? this.searchAllSources,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showMyAnimeList': showMyAnimeList,
      'showAniList': showAniList,
      'onlyShowPinnedSources': onlyShowPinnedSources,
      'searchAllSources': searchAllSources,
    };
  }

  factory BrowseSettings.fromJson(Map<String, dynamic> json) {
    return BrowseSettings(
      showMyAnimeList: json['showMyAnimeList'] ?? true,
      showAniList: json['showAniList'] ?? true,
      onlyShowPinnedSources: json['onlyShowPinnedSources'] ?? false,
      searchAllSources: json['searchAllSources'] ?? false,
    );
  }
}

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static const String _browseSettingsKey = 'browse_settings';
  static const _themeModeKey = 'theme_mode';
  static const _showUpdatesTabKey = 'show_updates_tab';
  static const _showLabelsInNavKey = 'show_labels_in_nav';

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? 0;
    return ThemeMode.values[themeModeIndex];
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, themeMode.index);
  }

  Future<bool> getShowUpdatesTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showUpdatesTabKey) ?? true;
  }

  Future<void> setShowUpdatesTab(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showUpdatesTabKey, value);
  }

  Future<bool> getShowLabelsInNav() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showLabelsInNavKey) ?? false;
  }

  Future<void> setShowLabelsInNav(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showLabelsInNavKey, value);
  }

  /// Get browse settings
  Future<BrowseSettings> getBrowseSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_browseSettingsKey);
      
      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        return BrowseSettings.fromJson(settingsMap);
      }
    } catch (e) {
      // If there's an error, return default settings
    }
    
    return const BrowseSettings();
  }

  /// Save browse settings
  Future<void> saveBrowseSettings(BrowseSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(settings.toJson());
      await prefs.setString(_browseSettingsKey, settingsJson);
    } catch (e) {
      // Handle error
    }
  }

  /// Update browse settings
  Future<void> updateBrowseSettings(BrowseSettings settings) async {
    await saveBrowseSettings(settings);
  }
}

