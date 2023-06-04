import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

    final pro = await FirebaseFirestore.instance.collection("Topping").get();
    List<Topping> toppingList = [];
    pro.docs.forEach((doc) {
      var s = doc.data();
      toppingList.add(Topping(
          id: doc.id,
          name: s["name"] ?? "Unamed Topping",
          price: s["price"] * 1.0,
          image: s["image"] ??
              "https://www.shutterstock.com/image-vector/bubble-tea-on-spoon-add-260nw-1712622337.jpg"));
    });
    emit(LoadedState(
      toppingList: toppingList,
    ));
  }
}
