import 'dart:async';

import 'package:coffee_shop_admin/services/blocs/topping_list/topping_list_event.dart';
import 'package:coffee_shop_admin/services/blocs/topping_list/topping_list_state.dart';
import 'package:coffee_shop_admin/services/models/topping.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToppingListBloc extends Bloc<ToppingListEvent, ToppingListState> {
  ToppingListBloc() : super(LoadingState()) {
    on<FetchData>(_mapFetchData);
  }

  Future<void> _mapFetchData(
      FetchData event, Emitter<ToppingListState> emit) async {
    emit(LoadingState());

    await Future.delayed(const Duration(seconds: 1), () {
      emit(LoadedState(
        toppingList: [
          Topping(
              name: 'Espresso (1 shot)',
              price: 10,
              id: '1',
              image:
                  'https://product.hstatic.net/1000075078/product/1645969436_caramel-macchiato-nong-lifestyle-1_187d60b2a52244c58a5c2fd24addef78.jpg'),
          Topping(
            name: 'Caramel',
            image:
                'https://product.hstatic.net/1000075078/product/1645969436_caramel-macchiato-nong-lifestyle-1_187d60b2a52244c58a5c2fd24addef78.jpg',
            id: '2',
            price: 5,
          )
        ],
      ));
    });
  }
}
