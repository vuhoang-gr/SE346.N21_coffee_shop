import 'dart:async';

import 'package:coffee_shop_app/services/blocs/product_store/product_store_event.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_state.dart';
import 'package:coffee_shop_app/services/models/food.dart';
import 'package:coffee_shop_app/temp/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductStoreBloc extends Bloc<ProductStoreEvent, ProductStoreState> {
  ProductStoreBloc() : super(LoadingState(initFoods: [])) {
    on<FetchData>(_mapFetchData);
    on<UpdateFavorite>(_mapUpdateFavorite);
  }

  Future<void> _mapFetchData(
      FetchData event, Emitter<ProductStoreState> emit) async {
    emit(LoadingState(initFoods: state.initFoods));
    await Future.delayed(const Duration(seconds: 1), () {
      Map<String, dynamic> foodObject = separateIntoNeededObject();

      emit(LoadedState(
        initFoods: state.initFoods,
        listFavoriteFood: foodObject["listFavoriteFood"],
        listOtherFood: foodObject["listOtherFood"],
      ));
    });
  }

  Future<void> _mapUpdateFavorite(
      UpdateFavorite event, Emitter<ProductStoreState> emit) async {
    emit(LoadingState(initFoods: state.initFoods));

    //update favorite
    event.food.isFavorite = !event.food.isFavorite;

    Map<String, dynamic> foodObject = separateIntoNeededObject();

    emit(LoadedState(
      initFoods: state.initFoods,
      listFavoriteFood: foodObject["listFavoriteFood"],
      listOtherFood: foodObject["listOtherFood"],
    ));
  }

  Map<String, dynamic> separateIntoNeededObject() {
    List<Food> favoriteFoods = [];
    List<Food> otherFoods = [];

    for (int i = 0; i < Data.products.length; i++) {
      Food food = Data.products[i];
      if (food.isFavorite) {
        favoriteFoods.add(food);
      } else {
        otherFoods.add(food);
      }
    }
    return {
      "listFavoriteFood": favoriteFoods,
      "listOtherFood": otherFoods,
    };
  }
}
