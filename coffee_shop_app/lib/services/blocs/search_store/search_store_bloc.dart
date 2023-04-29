import 'package:coffee_shop_app/services/blocs/search_store/search_store_event.dart';
import 'package:coffee_shop_app/services/blocs/search_store/search_store_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../temp/data.dart';
import '../../models/store.dart';

class SearchStoreBloc extends Bloc<SearchStoreEvent, SearchStoreState> {
  final TextEditingController controller = TextEditingController();
  SearchStoreBloc()
      : super(SearchStoreState(
            searchStoreResults: Data.storeAddress,
            searchFavoritesStoreResults: Data.favoriteStores)) {
    on<SearchTextChanged>(_mapSearchTextChangedToState);
    on<SearchClear>(_mapSearchClearToState);
  }

  void _mapSearchTextChangedToState(
      SearchTextChanged event, Emitter<SearchStoreState> emit) {
    List<Store> searchStoreResults = Data.storeAddress
        .where((store) => store.address
            .toString()
            .toLowerCase()
            .contains(event.searchText.toLowerCase()))
        .toList();
    List<Store> searchFavoriteStoreResult = Data.favoriteStores
        .where((store) => store.address
            .toString()
            .toLowerCase()
            .contains(event.searchText.toLowerCase()))
        .toList();
    emit(SearchStoreState(
        searchStoreResults: searchStoreResults,
        searchFavoritesStoreResults: searchFavoriteStoreResult));
  }

  void _mapSearchClearToState(
      SearchClear event, Emitter<SearchStoreState> emit) {
    controller.clear();
    emit(SearchStoreState(
        searchStoreResults: Data.storeAddress,
        searchFavoritesStoreResults: Data.favoriteStores));
  }
}
