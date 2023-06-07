import 'dart:async';

import 'package:coffee_shop_app/services/apis/food_api.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_event.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_state.dart';
import 'package:coffee_shop_app/services/models/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/constants/dimension.dart';

class ProductStoreBloc extends Bloc<ProductStoreEvent, ProductStoreState> {
  StreamSubscription<List<Food>>? _foodStoreSubscription;
  ProductStoreBloc() : super(LoadingState()) {
    on<FetchData>(_mapFetchData);
    on<UpdateFavorite>(_mapUpdateFavorite);
    on<GetDataFetched>(_mapGetDataFetched);
  }

  void _mapFetchData(FetchData event, Emitter<ProductStoreState> emit) {
    emit(LoadingState());
    _foodStoreSubscription?.cancel();
    _foodStoreSubscription =
        FoodAPI().fetchData(event.stateFood).listen((listFoods) {
      add(GetDataFetched(listFoods: listFoods));
    }, onError: (_) {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      add(GetDataFetched(listFoods: []));
    });
  }

  Future<void> _mapGetDataFetched(
      GetDataFetched event, Emitter<ProductStoreState> emit) async {
    emit(LoadingState());

    Map<String, dynamic> foodObject = separateIntoNeededObject(event.listFoods);

    emit(FetchedState(
      listFavoriteFood: foodObject["listFavoriteFood"],
      listOtherFood: foodObject["listOtherFood"],
    ));
  }

  Future<void> _mapUpdateFavorite(
      UpdateFavorite event, Emitter<ProductStoreState> emit) async {
    if (state is HasDataProductStoreState) {
      List<Food> prevFavFoods =
          (state as HasDataProductStoreState).listFavoriteFood;
      List<Food> prevOtherFoods =
          (state as HasDataProductStoreState).listOtherFood;
      event.food.isFavorite = !event.food.isFavorite;
      emit(LoadingState());

      _foodStoreSubscription?.pause();
      if (await FoodAPI().updateFavorite(event.food.id)) {
        //update favorite

        Map<String, dynamic> foodObject =
            separateIntoNeededObject(FoodAPI().currentFoods);

        emit(LoadedState(
          listFavoriteFood: foodObject["listFavoriteFood"],
          listOtherFood: foodObject["listOtherFood"],
        ));
      } else {
        event.food.isFavorite = !event.food.isFavorite;
        Fluttertoast.showToast(
            msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: Dimension.font14);
        emit(LoadedState(
          listFavoriteFood: prevFavFoods,
          listOtherFood: prevOtherFoods,
        ));
      }
      if (_foodStoreSubscription?.isPaused ?? false) {
        _foodStoreSubscription!.resume();
      }
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

  @override
  Future<void> close() {
    _foodStoreSubscription?.cancel();
    return super.close();
  }
}
