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

// State
class SettingsState extends Equatable {
  final BrowseSettings browseSettings;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  const SettingsState({
    this.browseSettings = const BrowseSettings(),
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    BrowseSettings? browseSettings,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return SettingsState(
      browseSettings: browseSettings ?? this.browseSettings,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    browseSettings,
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
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, hasError: false, errorMessage: null));
      
      final browseSettings = await _settingsService.getBrowseSettings();
      
      emit(state.copyWith(
        browseSettings: browseSettings,
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
    try {
      emit(state.copyWith(isLoading: true, hasError: false, errorMessage: null));
      
      await _settingsService.updateBrowseSettings(event.browseSettings);
      
      emit(state.copyWith(
        browseSettings: event.browseSettings,
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
}
