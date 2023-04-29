abstract class SearchProductEvent {}

class SearchTextChanged extends SearchProductEvent {
  final String searchText;

  SearchTextChanged({required this.searchText});
}

class SearchClear extends SearchProductEvent {}