import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'settings_service.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class UpdateBrowseSettingsEvent extends SettingsEvent {
  final BrowseSettings browseSettings;
  
  const UpdateBrowseSettingsEvent(this.browseSettings);

  @override
  List<Object?> get props => [browseSettings];
}

class UpdateThemeModeEvent extends SettingsEvent {
  final ThemeMode themeMode;

  const UpdateThemeModeEvent(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class UpdateShowUpdatesTabEvent extends SettingsEvent {
  final bool showUpdatesTab;

  const UpdateShowUpdatesTabEvent(this.showUpdatesTab);

  @override
  List<Object?> get props => [showUpdatesTab];
}

class UpdateShowLabelsInNavEvent extends SettingsEvent {
  final bool showLabelsInNav;

  const UpdateShowLabelsInNavEvent(this.showLabelsInNav);

  @override
  List<Object?> get props => [showLabelsInNav];
}

// State
class SettingsState extends Equatable {
  final BrowseSettings browseSettings;
  final ThemeMode themeMode;
  final bool showUpdatesTab;
  final bool showLabelsInNav;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  const SettingsState({
    this.browseSettings = const BrowseSettings(),
    this.themeMode = ThemeMode.system,
    this.showUpdatesTab = true,
    this.showLabelsInNav = false,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    BrowseSettings? browseSettings,
    ThemeMode? themeMode,
    bool? showUpdatesTab,
    bool? showLabelsInNav,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return SettingsState(
      browseSettings: browseSettings ?? this.browseSettings,
      themeMode: themeMode ?? this.themeMode,
      showUpdatesTab: showUpdatesTab ?? this.showUpdatesTab,
      showLabelsInNav: showLabelsInNav ?? this.showLabelsInNav,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    browseSettings,
    themeMode,
    showUpdatesTab,
    showLabelsInNav,
    isLoading,
    hasError,
    errorMessage,
  ];
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService _settingsService;

  SettingsBloc({required SettingsService settingsService})
      : _settingsService = settingsService,
        super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateBrowseSettingsEvent>(_onUpdateBrowseSettings);
    on<UpdateThemeModeEvent>(_onUpdateThemeMode);
    on<UpdateShowUpdatesTabEvent>(_onUpdateShowUpdatesTab);
    on<UpdateShowLabelsInNavEvent>(_onUpdateShowLabelsInNav);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, hasError: false, errorMessage: null));
      
      final browseSettings = await _settingsService.getBrowseSettings();
      final themeMode = await _settingsService.getThemeMode();
      final showUpdatesTab = await _settingsService.getShowUpdatesTab();
      final showLabelsInNav = await _settingsService.getShowLabelsInNav();
      
      emit(state.copyWith(
        browseSettings: browseSettings,
        themeMode: themeMode,
        showUpdatesTab: showUpdatesTab,
        showLabelsInNav: showLabelsInNav,
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

  Future<void> _onUpdateBrowseSettings(
    UpdateBrowseSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsService.updateBrowseSettings(event.browseSettings);
    emit(state.copyWith(browseSettings: event.browseSettings));
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsService.setThemeMode(event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onUpdateShowUpdatesTab(
    UpdateShowUpdatesTabEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsService.setShowUpdatesTab(event.showUpdatesTab);
    emit(state.copyWith(showUpdatesTab: event.showUpdatesTab));
  }

  Future<void> _onUpdateShowLabelsInNav(
    UpdateShowLabelsInNavEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsService.setShowLabelsInNav(event.showLabelsInNav);
    emit(state.copyWith(showLabelsInNav: event.showLabelsInNav));
  }
}

