import 'dart:async';

import 'package:coffee_shop_admin/services/blocs/topping_list/topping_list_event.dart';
import 'package:coffee_shop_admin/services/blocs/topping_list/topping_list_state.dart';
import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/temp/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToppingListBloc extends Bloc<ToppingListEvent, ToppingListState> {
  ToppingListBloc() : super(LoadingState(initFoods: [])) {
    on<FetchData>(_mapFetchData);
  }

  Future<void> _mapFetchData(
      FetchData event, Emitter<ToppingListState> emit) async {
    emit(LoadingState(initFoods: state.initFoods));
    await Future.delayed(const Duration(seconds: 1), () {
      Map<String, dynamic> foodObject = separateIntoNeededObject();

      emit(LoadedState(
        initFoods: state.initFoods,
        listFood: foodObject["listFood"],
      ));
    });
  }

  Map<String, dynamic> separateIntoNeededObject() {
    List<Drink> foods = [];

    for (int i = 0; i < Data.products.length; i++) {
      foods.add(Data.products[i]);
    }
    return {
      "listFood": foods,
    };
  }
}
