import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_leaf/widgets/Emptyview/empty_view.dart';
import 'package:moon_leaf/widgets/novel_cover.dart';
import 'package:moon_leaf/database/novel_info.dart';

// Placeholder for my BLoC.
class LibraryBloc extends Bloc<dynamic, dynamic> {
  LibraryBloc() : super(null) {
    on<dynamic>((event, emit) {});
  }
}

// Placeholder for navigation actions.
void navigateToNovel(BuildContext context, int novelId) {
  // Implement your navigation logic here.
  debugPrint('Navigating to novel with ID: $novelId');
}

// Placeholder for Redux actions. In a BLoC setup, this would be an event.
class UpdateLibraryEvent {}
class SetNovelEvent {}

// Placeholder for translation strings.
String getString(String key) {
  return key; // Returns the key itself for demonstration.
}

// A simple `xor` function for list management.
List<int> xor(List<int> list, List<int> other) {
  final result = [...list];
  for (final item in other) {
    if (result.contains(item)) {
      result.remove(item);
    } else {
      result.add(item);
    }
  }
  return result;
}

class LibraryView extends StatefulWidget {
  final int categoryId;
  final List<LibraryNovelInfo> novels;
  final List<int> selectedNovelIds;
  final Function(List<int>) setSelectedNovelIds;

  const LibraryView({
    super.key,
    required this.categoryId,
    required this.novels,
    required this.selectedNovelIds,
    required this.setSelectedNovelIds,
  });

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  bool _isRefreshing = false;

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // In a BLoC setup, you would dispatch an event here.
    // context.read<LibraryBloc>().add(UpdateLibraryEvent());
    await Future.delayed(const Duration(seconds: 1)); // Simulate a network call.

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // A BlocProvider would typically be higher up in the widget tree.
    // For this example, we'll assume it's available.
    // This is how you'd dispatch the Redux action analog in a BLoC pattern.
    // final bloc = BlocProvider.of<LibraryBloc>(context);

    if (widget.novels.isEmpty) {
      return const EmptyView(
        iconText: 'Σ(ಠ_ಠ)',
        description: 'libraryScreen.empty',
      );
    }

return RefreshIndicator(
  onRefresh: _onRefresh,
  child: ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: widget.novels.length,
    itemBuilder: (context, index) {
      final item = widget.novels[index];
      final isSelected = widget.selectedNovelIds.contains(item.novelId);

      return NovelCover(
        item: item,
        isSelected: isSelected,

        // let NovelCover know we're in "selection mode" when non-empty
        selectedNovels: widget.selectedNovelIds
            .map((id) => SourceNovelItem(novelId: id))
            .toList(),

        // RN: setSelected(xor(...)) on long press
        onLongPress: (int novelId) {
          widget.setSelectedNovelIds(
            xor(widget.selectedNovelIds, [novelId]),
          );
        },

        // RN: if none selected → navigate + setNovel
        // (NovelCover will auto-route taps to onLongPress when selection mode is active)
        onPress: () {
          navigateToNovel(context, item.novelId);
          // If/when you wire BLoC, do:
          // context.read<LibraryBloc>().add(SetNovelEvent(item));
        },
      );
    },
  ),
);

  }
}