import 'package:coffee_shop_app/services/blocs/recent_see_products/recent_see_products_event.dart';
import 'package:coffee_shop_app/services/blocs/recent_see_products/recent_see_products_state.dart';
import 'package:coffee_shop_app/services/functions/shared_preferences_helper.dart';
import 'package:coffee_shop_app/services/models/food.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../temp/data.dart';

class RecentSeeProductsBloc
    extends Bloc<RecentSeeProductsEvent, RecentSeeProductsState> {
  RecentSeeProductsBloc() : super(NotExistDataState()) {
    on<ListRecentSeeProductChanged>(_mapListRecentSeeProductChangedToState);
    on<ListRecentSeeProductLoaded>(_mapListRecentSeeProductLoadedToState);
  }

  Future<void> _mapListRecentSeeProductChangedToState(
      ListRecentSeeProductChanged event,
      Emitter<RecentSeeProductsState> emit) async {
    emit(LoadingDataState());
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

    emit(LoaddedDataState(recentSeeProducts: state.recentSeeProducts));
  }

  Future<void> _mapListRecentSeeProductLoadedToState(
      ListRecentSeeProductLoaded event,
      Emitter<RecentSeeProductsState> emit) async {
    emit(LoadingDataState());

    List<String> productsid = await SharedPreferencesHelper.getProducts();
    List<Food> products = [];

    for (int i = 0; i < productsid.length; i++) {
      Food? food =
          Data.products.firstWhere((element) => element.id == productsid[i]);
      products.add(food);
    }
    if (products.isEmpty) {
      emit(NotExistDataState());
    } else {
      emit(LoaddedDataState(recentSeeProducts: products));
    }
  }
}
