import '../../models/store.dart';

abstract class SearchStoreState {
  final List<Store> initStoreList;
  SearchStoreState({required this.initStoreList});
}

class LoadedListStore extends SearchStoreState {
  final List<Store> searchStoreResults;
  LoadedListStore({
    required super.initStoreList,
    required this.searchStoreResults,
  });
}

class LoadingListStore extends SearchStoreState {
  LoadingListStore({
    required super.initStoreList,
  });
}

class EmptyListStore extends SearchStoreState {
  EmptyListStore({
    required super.initStoreList,
  });
}
