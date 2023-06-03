import 'dart:async';

import 'package:coffee_shop_app/services/apis/food_api.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_event.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_state.dart';
import 'package:coffee_shop_app/services/models/food.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductStoreBloc extends Bloc<ProductStoreEvent, ProductStoreState> {
  ProductStoreBloc()
      : super(FoodAPI.currentFoods == null
            ? LoadingState()
            : FetchedState(initFoods: FoodAPI.currentFoods!)) {
    on<FetchData>(_mapFetchData);
    on<UpdateFavorite>(_mapUpdateFavorite);
    on<ChangeFetchedToLoaded>(_mapChangeFetchedToLoaded);
  }

  Future<void> _mapFetchData(
      FetchData event, Emitter<ProductStoreState> emit) async {
    emit(LoadingState());

    List<Food> foods = await FoodAPI().fetchData(
        stateFood: event.stateFood, stateTopping: event.stateTopping);

    FoodAPI.currentFoods = foods;
    
    Map<String, dynamic> foodObject = separateIntoNeededObject(foods);

    emit(LoadedState(
      initFoods: foods,
      listFavoriteFood: foodObject["listFavoriteFood"],
      listOtherFood: foodObject["listOtherFood"],
    ));
  }

  Future<void> _mapChangeFetchedToLoaded(
      ChangeFetchedToLoaded event, Emitter<ProductStoreState> emit) async {
    if (state is FetchedState) {
      List<Food> foods = (state as FetchedState).initFoods;
      emit(LoadingState());

      Map<String, dynamic> foodObject = separateIntoNeededObject(foods);

      emit(LoadedState(
        initFoods: foods,
        listFavoriteFood: foodObject["listFavoriteFood"],
        listOtherFood: foodObject["listOtherFood"],
      ));
    }
  }

  Future<void> _mapUpdateFavorite(
      UpdateFavorite event, Emitter<ProductStoreState> emit) async {
    if (state is LoadedState) {
      List<Food> foods = (state as LoadedState).initFoods;
      emit(LoadingState());

      //update favorite
      event.food.isFavorite = !event.food.isFavorite;

      Map<String, dynamic> foodObject = separateIntoNeededObject(foods);

      emit(LoadedState(
        initFoods: foods,
        listFavoriteFood: foodObject["listFavoriteFood"],
        listOtherFood: foodObject["listOtherFood"],
      ));
    }
  }

  Map<String, dynamic> separateIntoNeededObject(List<Food> foods) {
    List<Food> favoriteFoods = [];
    List<Food> otherFoods = [];

    for (int i = 0; i < foods.length; i++) {
      Food food = foods[i];
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
