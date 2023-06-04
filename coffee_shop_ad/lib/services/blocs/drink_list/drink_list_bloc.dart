import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/services/blocs/drink_list/drink_list_event.dart';
import 'package:coffee_shop_admin/services/blocs/drink_list/drink_list_state.dart';
import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/temp/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrinkListBloc extends Bloc<DrinkListEvent, DrinkListState> {
  DrinkListBloc() : super(LoadingState(initFoods: [])) {
    on<FetchData>(_mapFetchData);
  }

  Future<void> _mapFetchData(
      FetchData event, Emitter<DrinkListState> emit) async {
    final pro = await FirebaseFirestore.instance.collection("Food").get();
    List<Drink> drinkList = [];
    pro.docs.forEach((doc) {
      var s = doc.data();
      drinkList.add(Drink(
          id: doc.id,
          name: s["name"],
          price: s["price"] * 1.0,
          description: s["description"],
          sizes: [
            Data.sizes[0],
            Data.sizes[1],
          ],
          toppings: [
            Data.toopings[0],
            Data.toopings[1],
          ],
          images: s["images"]));
    });

    emit(LoadedState(
      initFoods: state.initFoods,
      listFood: drinkList,
    ));
  }
}
