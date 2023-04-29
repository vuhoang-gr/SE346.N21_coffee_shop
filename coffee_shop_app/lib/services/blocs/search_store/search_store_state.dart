import '../../models/store.dart';

class SearchStoreState {
  final List<Store> searchStoreResults;
  final List<Store> searchFavoritesStoreResults;
  SearchStoreState({required this.searchStoreResults, required this.searchFavoritesStoreResults});
}
