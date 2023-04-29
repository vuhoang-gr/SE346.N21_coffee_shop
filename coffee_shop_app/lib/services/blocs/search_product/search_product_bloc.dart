import 'package:coffee_shop_app/services/blocs/search_product/search_product_event.dart';
import 'package:coffee_shop_app/services/blocs/search_product/search_product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../temp/data.dart';
import '../../models/food.dart';

class SearchProductBloc extends Bloc<SearchProductEvent, SearchProductState> {
  final TextEditingController controller = TextEditingController();
  SearchProductBloc()
      : super(SearchProductState(searchResults: Data.products)) {
    on<SearchTextChanged>(_mapSearchTextChangedToState);
    on<SearchClear>(_mapSearchClearToState);
  }

  void _mapSearchTextChangedToState(
      SearchTextChanged event, Emitter<SearchProductState> emit) {
    List<Food> searchResults = Data.products
        .where((food) => food.name
            .toString()
            .toLowerCase()
            .contains(event.searchText.toLowerCase()))
        .toList();
    
    emit(SearchProductState(searchResults: searchResults));
  }

  void _mapSearchClearToState(
      SearchClear event, Emitter<SearchProductState> emit) {
    controller.clear();
    emit(SearchProductState(searchResults: Data.products));
  }
}
