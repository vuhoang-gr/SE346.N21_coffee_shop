import 'package:coffee_shop_app/services/blocs/search_store/search_store_event.dart';
import 'package:coffee_shop_app/services/blocs/search_store/search_store_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/store.dart';

class SearchStoreBloc extends Bloc<SearchStoreEvent, SearchStoreState> {
  final TextEditingController controller = TextEditingController();
  SearchStoreBloc() : super(LoadingListStore(initStoreList: [])) {
    on<SearchTextChanged>(_mapSearchTextChangedToState);
    on<SearchClear>(_mapSearchClearToState);
    on<UpdateList>(_mapUpdateList);
  }

  void _mapSearchTextChangedToState(
      SearchTextChanged event, Emitter<SearchStoreState> emit) {
    emit(LoadingListStore(initStoreList: state.initStoreList));
    List<Store> searchStoreResults = state.initStoreList
        .where((store) => store.address.formattedAddress
            .toString()
            .toLowerCase()
            .contains(event.searchText.toLowerCase()))
        .toList();
    if (searchStoreResults.isEmpty) {
      emit(EmptyListStore(initStoreList: state.initStoreList));
    } else {
      emit(LoadedListStore(
        initStoreList: state.initStoreList,
        searchStoreResults: searchStoreResults,
      ));
    }
  }

  void _mapSearchClearToState(
      SearchClear event, Emitter<SearchStoreState> emit) {
    emit(LoadingListStore(initStoreList: state.initStoreList));
    controller.clear();
    if (state.initStoreList.isEmpty) {
      emit(EmptyListStore(initStoreList: state.initStoreList));
    } else {
      emit(LoadedListStore(
        initStoreList: state.initStoreList,
        searchStoreResults: state.initStoreList,
      ));
    }
  }

  void _mapUpdateList(UpdateList event, Emitter<SearchStoreState> emit) {
    emit(LoadedListStore(
      initStoreList: event.listStore,
      searchStoreResults: event.listStore,
    ));
  }
}
