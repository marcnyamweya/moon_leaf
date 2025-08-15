import 'package:flutter/material.dart';


enum DisplayModes {comfortable, compact, list}

class LibraryNovelInfo {
  final int novelId;
  final String novelName;
  final String novelCover;
  final int sourceId;
  final int? chaptersDownloaded;
  final int? chaptersUnread;

  LibraryNovelInfo({
    required this.novelId,
    required this.novelName,
    required this.novelCover,
    required this.sourceId,
    this.chaptersDownloaded,
    this.chaptersUnread,
  });
}

class SourceNovelItem {
  final int novelId;
  const SourceNovelItem({required this.novelId});
}

class LibrarySettings {
  final DisplayModes displayMode;
  final bool showDownloadBadges;
  final bool showUnreadBadges;
  final int novelsPerRow;

  const LibrarySettings({
    this.displayMode = DisplayModes.comfortable,
    this.showDownloadBadges = true,
    this.showUnreadBadges = true,
    this.novelsPerRow = 3,
  });
}


class NovelCover extends StatelessWidget {
  final LibraryNovelInfo item;
  final VoidCallback onPress;
  final bool? libraryStatus;
  final bool? isSelected;
  final Function(int) onLongPress;
  final List<SourceNovelItem>? selectedNovels;
  final LibrarySettings settings;

  const NovelCover({
    super.key,
    required this.item,
    required this.onPress,
    this.libraryStatus,
    this.isSelected,
    required this.onLongPress,
    this.selectedNovels,
    this.settings = const LibrarySettings(),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    
    // Calculate columns based on orientation
    final numColumns = orientation == Orientation.landscape ? 6 : settings.novelsPerRow;
    final coverHeight = (screenWidth / numColumns) * (4 / 3);

    void selectNovel() => onLongPress(item.novelId);
    
    final hasSelectedNovels = selectedNovels != null && selectedNovels!.isNotEmpty;

    // Handle skeleton loading
    if (item.sourceId < 0) {
      return _buildSkeletonLoading();
    }

    // Handle list view
    if (settings.displayMode == DisplayModes.list) {
      return _buildListView(context);
    }

    // Standard cover view
    return Flexible(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isSelected == true 
              ? theme.colorScheme.primary.withValues(alpha: 0.8)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: hasSelectedNovels ? selectNovel : onPress,
            onLongPress: selectNovel,
            splashColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
            child: Padding(
              padding: const EdgeInsets.all(4.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // Cover image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            item.novelCover,
                            height: coverHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            color: libraryStatus == true 
                                ? Colors.black.withValues(alpha: 0.5) 
                                : null,
                            colorBlendMode: libraryStatus == true 
                                ? BlendMode.darken 
                                : null,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: coverHeight,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: coverHeight,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Badges
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Row(
                            children: [
                              if (libraryStatus == true)
                                const InLibraryBadge(),
                              if (settings.showDownloadBadges && 
                                  item.chaptersDownloaded != null)
                                DownloadBadge(
                                  chaptersDownloaded: item.chaptersDownloaded!,
                                  showUnreadBadges: settings.showUnreadBadges,
                                  chaptersUnread: item.chaptersUnread ?? 0,
                                ),
                              if (settings.showUnreadBadges && 
                                  item.chaptersUnread != null)
                                UnreadBadge(
                                  chaptersUnread: item.chaptersUnread!,
                                  chaptersDownloaded: item.chaptersDownloaded ?? 0,
                                  showDownloadBadges: settings.showDownloadBadges,
                                ),
                            ],
                          ),
                        ),
                        
                        // Compact title overlay
                        if (settings.displayMode == DisplayModes.compact)
                          Positioned(
                            bottom: 4,
                            left: 4,
                            right: 4,
                            child: CompactTitle(novelName: item.novelName),
                          ),
                      ],
                    ),
                  ),
                  
                  // Comfortable title
                  if (settings.displayMode == DisplayModes.comfortable)
                    ComfortableTitle(novelName: item.novelName),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return Container(
      margin: const EdgeInsets.all(2),
      child: Column(
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 16,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelectedNovels = selectedNovels != null && selectedNovels!.isNotEmpty;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isSelected == true 
            ? theme.colorScheme.primary.withValues(alpha: 0.8)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: hasSelectedNovels ? () => onLongPress(item.novelId) : onPress,
          onLongPress: () => onLongPress(item.novelId),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    item.novelCover,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.novelName,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (libraryStatus == true)
                      const InLibraryBadge(),
                    if (settings.showDownloadBadges && 
                        item.chaptersDownloaded != null)
                      DownloadBadge(
                        chaptersDownloaded: item.chaptersDownloaded!,
                        showUnreadBadges: settings.showUnreadBadges,
                        chaptersUnread: item.chaptersUnread ?? 0,
                      ),
                    if (settings.showUnreadBadges && 
                        item.chaptersUnread != null)
                      UnreadBadge(
                        chaptersUnread: item.chaptersUnread!,
                        chaptersDownloaded: item.chaptersDownloaded ?? 0,
                        showDownloadBadges: settings.showDownloadBadges,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Title Components
class ComfortableTitle extends StatelessWidget {
  final String novelName;

  const ComfortableTitle({
    super.key,
    required this.novelName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        novelName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CompactTitle extends StatelessWidget {
  final String novelName;

  const CompactTitle({
    super.key,
    required this.novelName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Color.fromRGBO(0, 0, 0, 0.7)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          novelName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Color.fromRGBO(0, 0, 0, 0.75),
                offset: Offset(-1, 1),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Badge Components
class InLibraryBadge extends StatelessWidget {
  const InLibraryBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'In library',
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 12,
        ),
      ),
    );
  }
}

class UnreadBadge extends StatelessWidget {
  final int chaptersUnread;
  final int chaptersDownloaded;
  final bool showDownloadBadges;

  const UnreadBadge({
    super.key,
    required this.chaptersUnread,
    required this.chaptersDownloaded,
    required this.showDownloadBadges,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    BorderRadius borderRadius;
    if (chaptersDownloaded == 0) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(4),
        bottomLeft: Radius.circular(4),
      );
    } else if (!showDownloadBadges) {
      borderRadius = BorderRadius.circular(4);
    } else {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(4),
        bottomRight: Radius.circular(4),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: borderRadius,
      ),
      child: Text(
        '$chaptersUnread',
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 12,
        ),
      ),
    );
  }
}

class DownloadBadge extends StatelessWidget {
  final int chaptersDownloaded;
  final bool showUnreadBadges;
  final int chaptersUnread;

  const DownloadBadge({
    super.key,
    required this.chaptersDownloaded,
    required this.showUnreadBadges,
    required this.chaptersUnread,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    BorderRadius borderRadius;
    if (chaptersUnread == 0) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(4),
        bottomRight: Radius.circular(4),
      );
    } else if (!showUnreadBadges) {
      borderRadius = BorderRadius.circular(4);
    } else {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(4),
        bottomLeft: Radius.circular(4),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary,
        borderRadius: borderRadius,
      ),
      child: Text(
        '$chaptersDownloaded',
        style: TextStyle(
          color: theme.colorScheme.onTertiary,
          fontSize: 12,
        ),
      ),
    );
  }
}