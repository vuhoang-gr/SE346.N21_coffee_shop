import 'dart:async';

import 'package:coffee_shop_app/services/apis/food_api.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_state.dart'
    as product_store_state;
import 'package:coffee_shop_app/services/blocs/recent_see_products/recent_see_products_event.dart';
import 'package:coffee_shop_app/services/blocs/recent_see_products/recent_see_products_state.dart';
import 'package:coffee_shop_app/services/functions/shared_preferences_helper.dart';
import 'package:coffee_shop_app/services/models/food.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentSeeProductsBloc
    extends Bloc<RecentSeeProductsEvent, RecentSeeProductsState> {
  final ProductStoreBloc _productStoreBloc;
  late StreamSubscription _productStoreSubscription;
  RecentSeeProductsBloc(this._productStoreBloc)
      : super(LoadingState(recentSeeProducts: [])) {
    on<ListRecentSeeProductChanged>(_mapListRecentSeeProductChangedToState);
    on<ListRecentSeeProductLoaded>(_mapListRecentSeeProductLoadedToState);

    _productStoreSubscription = _productStoreBloc.stream.listen((state) {
      if (state is product_store_state.FetchedState) {
        add(ListRecentSeeProductLoaded());
      }
    });
  }

  Future<void> _mapListRecentSeeProductChangedToState(
      ListRecentSeeProductChanged event,
      Emitter<RecentSeeProductsState> emit) async {
    emit(LoadingState(recentSeeProducts: state.recentSeeProducts));
    await SharedPreferencesHelper.addProductToSharedPreferences(
        event.product.id);
    if (state.recentSeeProducts
            .indexWhere((element) => element.id == event.product.id) ==
        -1) {
      while (state.recentSeeProducts.length >= 8) {
        state.recentSeeProducts.removeLast();
      }
    } else {
      state.recentSeeProducts
          .removeWhere((element) => element.id == event.product.id);
    }

    state.recentSeeProducts.insert(0, event.product);

    emit(LoadedState(recentSeeProducts: state.recentSeeProducts));
  }

  Future<void> _mapListRecentSeeProductLoadedToState(
      ListRecentSeeProductLoaded event,
      Emitter<RecentSeeProductsState> emit) async {
    emit(LoadingState(recentSeeProducts: state.recentSeeProducts));

    List<String> productsid = await SharedPreferencesHelper.getProducts();
    List<Food> products = [];

    for (int i = 0; i < productsid.length; i++) {
      try {
        Food? food = FoodAPI()
            .currentFoods
            .firstWhere((element) => element.id == productsid[i]);
        products.add(food);
      } catch (e) {
        //The inintFoods doesn't have this food
      }
    }

    emit(LoadedState(recentSeeProducts: products));
  }

  @override
  Future<void> close() {
    _productStoreSubscription.cancel();
    return super.close();
  }
}
