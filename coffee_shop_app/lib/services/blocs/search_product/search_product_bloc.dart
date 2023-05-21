
import 'package:coffee_shop_app/services/blocs/search_product/search_product_event.dart';
import 'package:coffee_shop_app/services/blocs/search_product/search_product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/food.dart';

class SearchProductBloc extends Bloc<SearchProductEvent, SearchProductState> {
  final TextEditingController controller = TextEditingController();
  SearchProductBloc() : super(LoadingListFood(initProductList: [])) {
    on<SearchTextChanged>(_mapSearchTextChangedToState);
    on<SearchClear>(_mapSearchClearToState);
    on<UpdateList>(_mapUpdateList);
  }

  void _mapSearchTextChangedToState(
      SearchTextChanged event, Emitter<SearchProductState> emit) {
    emit(LoadingListFood(initProductList: state.initProductList));
    List<Food> searchFoodResults = state.initProductList
        .where((product) => product.name
            .toString()
            .toLowerCase()
            .contains(event.searchText.toLowerCase()))
        .toList();
    if (searchFoodResults.isEmpty) {
      emit(EmptyListFood(initProductList: state.initProductList));
    } else {
      emit(LoadedListFood(
        initProductList: state.initProductList,
        searchStoreResults: searchFoodResults, 
      ));
    }
  }

  void _mapSearchClearToState(
      SearchClear event, Emitter<SearchProductState> emit) {
    emit(LoadingListFood(initProductList: state.initProductList));
    controller.clear();
    if (state.initProductList.isEmpty) {
      emit(EmptyListFood(initProductList: state.initProductList));
    } else {
      emit(LoadedListFood(
        initProductList: state.initProductList,
        searchStoreResults: state.initProductList,
      ));
    }
  }

  void _mapUpdateList(UpdateList event, Emitter<SearchProductState> emit) {
    emit(LoadedListFood(
      initProductList: event.initListFood,
      searchStoreResults: event.initListFood,
    ));
  }
}