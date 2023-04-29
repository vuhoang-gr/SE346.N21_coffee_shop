abstract class SearchStoreEvent {}

class SearchTextChanged extends SearchStoreEvent {
  final String searchText;

  SearchTextChanged({required this.searchText});
}

class SearchClear extends SearchStoreEvent {}