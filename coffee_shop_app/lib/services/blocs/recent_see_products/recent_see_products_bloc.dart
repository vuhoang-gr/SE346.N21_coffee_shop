import 'package:coffee_shop_app/services/apis/food_api.dart';
import 'package:coffee_shop_app/services/blocs/recent_see_products/recent_see_products_event.dart';
import 'package:coffee_shop_app/services/blocs/recent_see_products/recent_see_products_state.dart';
import 'package:coffee_shop_app/services/functions/shared_preferences_helper.dart';
import 'package:coffee_shop_app/services/models/food.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentSeeProductsBloc
    extends Bloc<RecentSeeProductsEvent, RecentSeeProductsState> {
  RecentSeeProductsBloc() : super(LoadingState()) {
    on<ListRecentSeeProductChanged>(_mapListRecentSeeProductChangedToState);
    on<ListRecentSeeProductLoaded>(_mapListRecentSeeProductLoadedToState);
  }

  Future<void> _mapListRecentSeeProductChangedToState(
      ListRecentSeeProductChanged event,
      Emitter<RecentSeeProductsState> emit) async {
    emit(LoadingState());
    await SharedPreferencesHelper.addProductToSharedPreferences(
        event.product.id);

    if (state.recentSeeProducts
            .indexWhere((element) => element.id == event.product.id) !=
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
    emit(LoadingState());

    List<String> productsid = await SharedPreferencesHelper.getProducts();
    List<Food> products = [];

    if (FoodAPI.currentFoods != null) {
      for (int i = 0; i < productsid.length; i++) {
        Food? food = FoodAPI.currentFoods!
            .firstWhere((element) => element.id == productsid[i]);
        products.add(food);
      }
    }

    if (products.isEmpty) {
      emit(NotExistState());
    } else {
      emit(LoadedState(recentSeeProducts: products));
    }
  }
}
