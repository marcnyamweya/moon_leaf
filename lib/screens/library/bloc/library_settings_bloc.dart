import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../constants/constants.dart';

class LibrarySettingsState extends Equatable {
  const LibrarySettingsState({
    this.filter,
    this.sortOrder = LibrarySortOrder.dateAddedDesc,
    this.showDownloadBadges = true,
    this.showNumberOfNovels = false,
    this.showUnreadBadges = true,
    this.displayMode = DisplayModes.comfortable,
  });

  final LibraryFilter? filter;
  final LibrarySortOrder sortOrder;
  final bool showDownloadBadges;
  final bool showNumberOfNovels;
  final bool showUnreadBadges;
  final DisplayModes displayMode;

  @override
  List<Object?> get props => [
    filter,
    sortOrder,
    showDownloadBadges,
    showNumberOfNovels,
    showUnreadBadges,
    displayMode,
  ];

  LibrarySettingsState copyWith({
    LibraryFilter? filter,
    LibrarySortOrder? sortOrder,
    bool? showDownloadBadges,
    bool? showNumberOfNovels,
    bool? showUnreadBadges,
    DisplayModes? displayMode,
  }) {
    return LibrarySettingsState(
      filter: filter ?? this.filter,
      sortOrder: sortOrder ?? this.sortOrder,
      showDownloadBadges: showDownloadBadges ?? this.showDownloadBadges,
      showNumberOfNovels: showNumberOfNovels ?? this.showNumberOfNovels,
      showUnreadBadges: showUnreadBadges ?? this.showUnreadBadges,
      displayMode: displayMode ?? this.displayMode,
    );
  }
}

// The event classes, representing actions that can be taken on the state.
@immutable
abstract class LibrarySettingsEvent extends Equatable {
  const LibrarySettingsEvent();

  @override
  List<Object?> get props => [];
}

class UpdateFilter extends LibrarySettingsEvent {
  const UpdateFilter(this.filter);

  final LibraryFilter? filter;

  @override
  List<Object?> get props => [filter];
}

class UpdateSortOrder extends LibrarySettingsEvent {
  const UpdateSortOrder(this.sortOrder);

  final LibrarySortOrder sortOrder;

  @override
  List<Object> get props => [sortOrder];
}

class UpdateShowDownloadBadges extends LibrarySettingsEvent {
  const UpdateShowDownloadBadges(this.showDownloadBadges);

  final bool showDownloadBadges;

  @override
  List<Object> get props => [showDownloadBadges];
}

class UpdateShowNumberOfNovels extends LibrarySettingsEvent {
  const UpdateShowNumberOfNovels(this.showNumberOfNovels);

  final bool showNumberOfNovels;

  @override
  List<Object> get props => [showNumberOfNovels];
}

class UpdateShowUnreadBadges extends LibrarySettingsEvent {
  const UpdateShowUnreadBadges(this.showUnreadBadges);

  final bool showUnreadBadges;

  @override
  List<Object> get props => [showUnreadBadges];
}

class UpdateDisplayMode extends LibrarySettingsEvent {
  const UpdateDisplayMode(this.displayMode);

  final DisplayModes displayMode;

  @override
  List<Object> get props => [displayMode];
}

// The BLoC class.
class LibrarySettingsBloc
    extends Bloc<LibrarySettingsEvent, LibrarySettingsState> {
  LibrarySettingsBloc() : super(const LibrarySettingsState()) {
    on<UpdateFilter>((event, emit) {
      emit(state.copyWith(filter: event.filter));
    });

    on<UpdateSortOrder>((event, emit) {
      emit(state.copyWith(sortOrder: event.sortOrder));
    });

    on<UpdateShowDownloadBadges>((event, emit) {
      emit(state.copyWith(showDownloadBadges: event.showDownloadBadges));
    });

    on<UpdateShowNumberOfNovels>((event, emit) {
      emit(state.copyWith(showNumberOfNovels: event.showNumberOfNovels));
    });

    on<UpdateShowUnreadBadges>((event, emit) {
      emit(state.copyWith(showUnreadBadges: event.showUnreadBadges));
    });

    on<UpdateDisplayMode>((event, emit) {
      emit(state.copyWith(displayMode: event.displayMode));
    });
  }
}