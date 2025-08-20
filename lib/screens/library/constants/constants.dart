// The imports for translations will depend on your project setup.
// Example: import 'package:your_project/strings/translations.dart';

enum LibraryFilter {
  downloaded,
  unread,
  completed,
  downloadedOnly,
  started,
}

const libraryFilterList = [
  {
    'label': 'Downloaded', // getString('libraryScreen.bottomSheet.filters.downloaded'),
    'filter': LibraryFilter.downloaded,
  },
  {
    'label': 'Unread', // getString('libraryScreen.bottomSheet.filters.unread'),
    'filter': LibraryFilter.unread,
  },
  {
    'label': 'Started', // getString('libraryScreen.bottomSheet.filters.started'),
    'filter': LibraryFilter.started,
  },
  {
    'label': 'Completed', // getString('libraryScreen.bottomSheet.filters.completed'),
    'filter': LibraryFilter.completed,
  },
];

enum LibrarySortOrder {
  alphabeticallyAsc,
  alphabeticallyDesc,
  unreadAsc,
  unreadDesc,
  downloadedAsc,
  downloadedDesc,
  totalChaptersAsc,
  totalChaptersDesc,
  dateAddedAsc,
  dateAddedDesc,
  lastReadAsc,
  lastReadDesc,
  lastUpdatedAsc,
  lastUpdatedDesc,
}

const librarySortOrderList = [
  {
    'label': 'Alphabetically', // getString('libraryScreen.bottomSheet.sortOrders.alphabetically'),
    'asc': LibrarySortOrder.alphabeticallyAsc,
    'desc': LibrarySortOrder.alphabeticallyDesc,
  },
  {
    'label': 'Last Read', // getString('libraryScreen.bottomSheet.sortOrders.lastRead'),
    'asc': LibrarySortOrder.lastReadAsc,
    'desc': LibrarySortOrder.lastReadDesc,
  },
  {
    'label': 'Last Updated', // getString('libraryScreen.bottomSheet.sortOrders.lastUpdated'),
    'asc': LibrarySortOrder.lastUpdatedAsc,
    'desc': LibrarySortOrder.lastUpdatedDesc,
  },
  {
    'label': 'Unread', // getString('libraryScreen.bottomSheet.sortOrders.unread'),
    'asc': LibrarySortOrder.unreadAsc,
    'desc': LibrarySortOrder.unreadDesc,
  },
  {
    'label': 'Download', // getString('libraryScreen.bottomSheet.sortOrders.download'),
    'asc': LibrarySortOrder.downloadedAsc,
    'desc': LibrarySortOrder.downloadedDesc,
  },
  {
    'label': 'Total Chapters', // getString('libraryScreen.bottomSheet.sortOrders.totalChapters'),
    'asc': LibrarySortOrder.totalChaptersAsc,
    'desc': LibrarySortOrder.totalChaptersDesc,
  },
  {
    'label': 'Date Added', // getString('libraryScreen.bottomSheet.sortOrders.dateAdded'),
    'asc': LibrarySortOrder.dateAddedAsc,
    'desc': LibrarySortOrder.dateAddedDesc,
  },
];

enum DisplayModes {
  compact,
  comfortable,
  coverOnly,
  list,
}

const displayModesList = [
  {
    'label': 'Compact', // getString('libraryScreen.bottomSheet.display.compact'),
    'value': DisplayModes.compact,
  },
  {
    'label': 'Comfortable', // getString('libraryScreen.bottomSheet.display.comfortable'),
    'value': DisplayModes.comfortable,
  },
  {
    'label': 'Cover Only', // getString('libraryScreen.bottomSheet.display.noTitle'),
    'value': DisplayModes.coverOnly,
  },
  {
    'label': 'List', // getString('libraryScreen.bottomSheet.display.list'),
    'value': DisplayModes.list,
  },
];