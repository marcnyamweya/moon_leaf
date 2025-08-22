import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moon_leaf/database/novel_info.dart';

// Settings State
class SettingsState extends Equatable {
  final Map<String, dynamic> settings;

  const SettingsState({
    this.settings = const {},
  });

  SettingsState copyWith({
    Map<String, dynamic>? settings,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object> get props => [settings];
}

// Novel State
class NovelState extends Equatable {
  final Map<String, dynamic> novel;

  const NovelState({
    this.novel = const {},
  });

  NovelState copyWith({
    Map<String, dynamic>? novel,
  }) {
    return NovelState(
      novel: novel ?? this.novel,
    );
  }

  @override
  List<Object> get props => [novel];
}

// Preference State
class PreferenceState extends Equatable {
  final Map<String, NovelSettings> novelSettings;

  const PreferenceState({
    this.novelSettings = const {},
  });

  PreferenceState copyWith({
    Map<String, NovelSettings>? novelSettings,
  }) {
    return PreferenceState(
      novelSettings: novelSettings ?? this.novelSettings,
    );
  }

  @override
  List<Object> get props => [novelSettings];
}

// Novel Settings Model
class NovelSettings extends Equatable {
  final String? sort;
  final String? filter;
  final Map<String, double>? position;
  final bool? showChapterTitles;
  final String? lastRead;

  const NovelSettings({
    this.sort,
    this.filter,
    this.position,
    this.showChapterTitles,
    this.lastRead,
  });

  NovelSettings copyWith({
    String? sort,
    String? filter,
    Map<String, double>? position,
    bool? showChapterTitles,
    String? lastRead,
  }) {
    return NovelSettings(
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
      position: position ?? this.position,
      showChapterTitles: showChapterTitles ?? this.showChapterTitles,
      lastRead: lastRead ?? this.lastRead,
    );
  }

  @override
  List<Object?> get props => [sort, filter, position, showChapterTitles, lastRead];
}

// Chapter Model


// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateSettings extends SettingsEvent {
  final Map<String, dynamic> settings;

  const UpdateSettings(this.settings);

  @override
  List<Object> get props => [settings];
}

abstract class NovelEvent extends Equatable {
  const NovelEvent();

  @override
  List<Object> get props => [];
}

class LoadNovel extends NovelEvent {}

class UpdateNovel extends NovelEvent {
  final Map<String, dynamic> novel;

  const UpdateNovel(this.novel);

  @override
  List<Object> get props => [novel];
}

abstract class PreferenceEvent extends Equatable {
  const PreferenceEvent();

  @override
  List<Object> get props => [];
}

class LoadPreferences extends PreferenceEvent {}

class UpdateNovelSettings extends PreferenceEvent {
  final String novelId;
  final NovelSettings settings;

  const UpdateNovelSettings(this.novelId, this.settings);

  @override
  List<Object> get props => [novelId, settings];
}

// BLoCs


class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    // Load settings from storage/repository
    // emit(state.copyWith(settings: loadedSettings));
  }

  void _onUpdateSettings(UpdateSettings event, Emitter<SettingsState> emit) {
    emit(state.copyWith(settings: event.settings));
  }
}

class NovelBloc extends Bloc<NovelEvent, NovelState> {
  NovelBloc() : super(const NovelState()) {
    on<LoadNovel>(_onLoadNovel);
    on<UpdateNovel>(_onUpdateNovel);
  }

  void _onLoadNovel(LoadNovel event, Emitter<NovelState> emit) {
    // Load novel from storage/repository
    // emit(state.copyWith(novel: loadedNovel));
  }

  void _onUpdateNovel(UpdateNovel event, Emitter<NovelState> emit) {
    emit(state.copyWith(novel: event.novel));
  }
}

class PreferenceBloc extends Bloc<PreferenceEvent, PreferenceState> {
  PreferenceBloc() : super(const PreferenceState()) {
    on<LoadPreferences>(_onLoadPreferences);
    on<UpdateNovelSettings>(_onUpdateNovelSettings);
  }

  void _onLoadPreferences(LoadPreferences event, Emitter<PreferenceState> emit) {
    // Load preferences from storage/repository
    // emit(state.copyWith(novelSettings: loadedSettings));
  }

  void _onUpdateNovelSettings(UpdateNovelSettings event, Emitter<PreferenceState> emit) {
    final updatedSettings = Map<String, NovelSettings>.from(state.novelSettings);
    updatedSettings[event.novelId] = event.settings;
    emit(state.copyWith(novelSettings: updatedSettings));
  }
}

// Hook-like utility functions


class BlocHooks {
  // Equivalent to useSettings
  static Map<String, dynamic> useSettings(BuildContext context) {
    return context.watch<SettingsBloc>().state.settings;
  }

  // Equivalent to useNovel
  static Map<String, dynamic> useNovel(BuildContext context) {
    return context.watch<NovelBloc>().state.novel;
  }

  // Equivalent to useFindNovel
  static NovelSettings? useFindNovel(BuildContext context, String novelId) {
    final novelSettings = context.watch<PreferenceBloc>().state.novelSettings;
    return novelSettings[novelId];
  }

  // Equivalent to usePreferences
  static NovelPreferences usePreferences(BuildContext context, String novelId) {
    final novel = useFindNovel(context, novelId);
    
    return NovelPreferences(
      sort: novel?.sort,
      filter: novel?.filter,
      position: novel?.position,
      showChapterTitles: novel?.showChapterTitles,
    );
  }

  // Equivalent to useSavedSettings
  static Map<String, NovelSettings> useSavedSettings(BuildContext context) {
    return context.watch<PreferenceBloc>().state.novelSettings;
  }

  // Equivalent to useContinueReading
  static ContinueReadingResult useContinueReading(
    BuildContext context,
    List<ChapterItemExtended> chapters,
    String novelId,
  ) {
    ChapterItemExtended? lastReadChapter;
    String? chapterId;
    NovelSettings? novel;
    Map<String, double>? position;

    novel = useFindNovel(context, novelId);
    if (novel != null) {
      chapterId = novel.lastRead;
      position = novel.position;
    }

    if (chapterId != null) {
      try {
        lastReadChapter = chapters.firstWhere(
          (obj) => obj.chapterId == chapterId && obj.read == 0,
        );
      } catch (e) {
        lastReadChapter = null;
      }
    }

    // If the last read chapter is 100% done, set the next chapter as the 'last read'.
    // If all chapters are read, then set the last chapter in the list as the last read
    if (lastReadChapter == null) {
      try {
        lastReadChapter = chapters.firstWhere((obj) => obj.read == 0);
      } catch (e) {
        lastReadChapter = chapters.isNotEmpty ? chapters.last : null;
      }
    }

    return ContinueReadingResult(
      lastReadChapter: lastReadChapter,
      position: position,
    );
  }

  // Equivalent to usePosition
  static double? usePosition(BuildContext context, String novelId, String chapterId) {
    final novel = useFindNovel(context, novelId);
    
    if (novel != null && novel.position != null) {
      return novel.position![chapterId];
    }
    
    return null;
  }
}

// Helper classes
class NovelPreferences {
  final String? sort;
  final String? filter;
  final Map<String, double>? position;
  final bool? showChapterTitles;

  const NovelPreferences({
    this.sort,
    this.filter,
    this.position,
    this.showChapterTitles,
  });
}

class ContinueReadingResult {
  final ChapterItem? lastReadChapter;
  final Map<String, double>? position;

  const ContinueReadingResult({
    this.lastReadChapter,
    this.position,
  });
}