class NovelInfo {
  final int novelId;
  final String sourceUrl;
  final String novelUrl;
  final int sourceId;
  final String source;
  final String novelName;
  final String novelCover;
  final String novelSummary;
  final String genre;
  final String author;
  final String status;
  final int followed;
  final String categoryIds;

  NovelInfo({
    required this.novelId,
    required this.sourceUrl,
    required this.novelUrl,
    required this.sourceId,
    required this.source,
    required this.novelName,
    required this.novelCover,
    required this.novelSummary,
    required this.genre,
    required this.author,
    required this.status,
    required this.followed,
    required this.categoryIds,
  });
}

class LibraryNovelInfo extends NovelInfo {
  final int? chaptersUnread;
  final int? chaptersDownloaded;

  LibraryNovelInfo({
    required super.novelId,
    required super.sourceUrl,
    required super.novelUrl,
    required super.sourceId,
    required super.source,
    required super.novelName,
    required super.novelCover,
    required super.novelSummary,
    required super.genre,
    required super.author,
    required super.status,
    required super.followed,
    required super.categoryIds,
    this.chaptersUnread,
    this.chaptersDownloaded,
  });
}

class Category {
  final int id;
  final String name;
  final DateTime lastUpdatedAt;

  Category({
    required this.id,
    required this.name,
    required this.lastUpdatedAt,
  });
}

class HistoryItem {
  final int historyId;
  final int sourceId;
  final int novelId;
  final int chapterId;
  final String novelName;
  final String novelUrl;
  final String novelCover;
  final String chapterName;
  final String chapterUrl;
  final String historyTimeRead;
  final int bookmark;

  HistoryItem({
    required this.historyId,
    required this.novelId,
    required this.sourceId,
    required this.chapterId,
    required this.novelName,
    required this.novelUrl,
    required this.novelCover,
    required this.chapterName,
    required this.chapterUrl,
    required this.historyTimeRead,
    required this.bookmark,
  });
}
