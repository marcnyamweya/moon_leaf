class Source {
  final int sourceId;
  final String sourceName;
  final String url;
  final String lang;
  final String icon;
  final bool? isNsfw;

  Source({
    required this.sourceId,
    required this.sourceName,
    required this.url,
    required this.lang,
    required this.icon,
    this.isNsfw,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      sourceId: json['sourceId'],
      sourceName: json['sourceName'],
      url: json['url'],
      lang: json['lang'],
      icon: json['icon'],
      isNsfw: json['isNsfw'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sourceId': sourceId,
      'sourceName': sourceName,
      'url': url,
      'lang': lang,
      'icon': icon,
      'isNsfw': isNsfw,
    };
  }
}

class SourceNovelItem {
  final int sourceId;
  final String novelName;
  final String novelUrl;
  final String? novelCover;

  SourceNovelItem({
    required this.sourceId,
    required this.novelName,
    required this.novelUrl,
    this.novelCover,
  });

  factory SourceNovelItem.fromJson(Map<String, dynamic> json) {
    return SourceNovelItem(
      sourceId: json['sourceId'],
      novelName: json['novelName'],
      novelUrl: json['novelUrl'],
      novelCover: json['novelCover'],
    );
  }
}

class SourceChapterItem {
  final String chapterName;
  final String chapterUrl;
  final String? releaseDate;

  SourceChapterItem({
    required this.chapterName,
    required this.chapterUrl,
    this.releaseDate,
  });

  factory SourceChapterItem.fromJson(Map<String, dynamic> json) {
    return SourceChapterItem(
      chapterName: json['chapterName'],
      chapterUrl: json['chapterUrl'],
      releaseDate: json['releaseDate'],
    );
  }
}

class SourceNovel {
  final int sourceId;
  final String sourceName;
  final String url;
  final String novelUrl;
  final String? novelName;
  final String? novelCover;
  final String? genre;
  final String? summary;
  final String? author;
  final NovelStatus? status;
  final List<SourceChapterItem>? chapters;

  SourceNovel({
    required this.sourceId,
    required this.sourceName,
    required this.url,
    required this.novelUrl,
    this.novelName,
    this.novelCover,
    this.genre,
    this.summary,
    this.author,
    this.status,
    this.chapters,
  });

  factory SourceNovel.fromJson(Map<String, dynamic> json) {
    return SourceNovel(
      sourceId: json['sourceId'],
      sourceName: json['sourceName'],
      url: json['url'],
      novelUrl: json['novelUrl'],
      novelName: json['novelName'],
      novelCover: json['novelCover'],
      genre: json['genre'],
      summary: json['summary'],
      author: json['author'],
      status: json['status'] != null 
          ? NovelStatus.values.firstWhere(
              (e) => e.toString().split('.').last == json['status'],
              orElse: () => NovelStatus.unknown)
          : null,
      chapters: json['chapters'] != null
          ? (json['chapters'] as List)
              .map((chapter) => SourceChapterItem.fromJson(chapter))
              .toList()
          : null,
    );
  }
}

class SourceChapter {
  final int sourceId;
  final String novelUrl;
  final String chapterUrl;
  final String? chapterName;
  final String? chapterText;

  SourceChapter({
    required this.sourceId,
    required this.novelUrl,
    required this.chapterUrl,
    this.chapterName,
    this.chapterText,
  });

  factory SourceChapter.fromJson(Map<String, dynamic> json) {
    return SourceChapter(
      sourceId: json['sourceId'],
      novelUrl: json['novelUrl'],
      chapterUrl: json['chapterUrl'],
      chapterName: json['chapterName'],
      chapterText: json['chapterText'],
    );
  }
}

enum NovelStatus {
  unknown,
  ongoing,
  completed,
  licensed,
  publishingFinished,
  cancelled,
  onHiatus,
}

extension NovelStatusExtension on NovelStatus {
  String get displayName {
    switch (this) {
      case NovelStatus.unknown:
        return 'Unknown';
      case NovelStatus.ongoing:
        return 'Ongoing';
      case NovelStatus.completed:
        return 'Completed';
      case NovelStatus.licensed:
        return 'Licensed';
      case NovelStatus.publishingFinished:
        return 'Publishing Finished';
      case NovelStatus.cancelled:
        return 'Cancelled';
      case NovelStatus.onHiatus:
        return 'On Hiatus';
    }
  }
}