import '../../models/store.dart';

abstract class SearchStoreEvent {}

class SearchTextChanged extends SearchStoreEvent {
  final String searchText;

  SearchTextChanged({required this.searchText});
}

class SearchClear extends SearchStoreEvent {}

class UpdateList extends SearchStoreEvent {
  List<Store> listStore;
  UpdateList({required this.listStore});
}
