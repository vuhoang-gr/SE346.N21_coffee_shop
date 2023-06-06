// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/services/blocs/drink_list/drink_list_event.dart';
import 'package:coffee_shop_admin/services/blocs/drink_list/drink_list_state.dart';
import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/services/models/size.dart';
import 'package:coffee_shop_admin/services/models/topping.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrinkListBloc extends Bloc<DrinkListEvent, DrinkListState> {
  DrinkListBloc() : super(LoadingState(initFoods: [])) {
    on<FetchData>(_mapFetchData);
  }

  Future<void> _mapFetchData(
      FetchData event, Emitter<DrinkListState> emit) async {
    emit(LoadingState(initFoods: []));

    final proTopping =
        await FirebaseFirestore.instance.collection("Topping").get();
    Drink.toppings = [];
    proTopping.docs.forEach((doc) {
      var s = doc.data();
      Drink.toppings.add(Topping(
          id: doc.id,
          name: s["name"] ?? "Unamed Topping",
          price: s["price"] * 1.0,
          image: s["image"] ??
              "https://www.shutterstock.com/image-vector/bubble-tea-on-spoon-add-260nw-1712622337.jpg"));
    });
    final proSize = await FirebaseFirestore.instance.collection("Size").get();
    Drink.sizes = [];
    proSize.docs.forEach((doc) {
      var s = doc.data();
      Drink.sizes.add(Size(
          id: doc.id,
          name: s["name"] ?? "Unamed Size",
          price: s["price"] * 1.0,
          image: s["image"] ??
              "https://www.shutterstock.com/image-vector/bubble-tea-on-spoon-add-260nw-1712622337.jpg"));
    });

    final pro = await FirebaseFirestore.instance.collection("Food").get();
    List<Drink> drinkList = [];
    pro.docs.forEach((doc) {
      var s = doc.data();
      List<bool> selectedSize = [];
      List<dynamic> tmp = s["sizes"] ?? [];
      for (int i = 0; i < Drink.sizes.length; i++) {
        String id = Drink.sizes[i].id;
        bool ok = false;
        for (int j = 0; j < tmp.length; j++) {
          if ((tmp[j] as String) == id) {
            ok = true;
            break;
          }
        }
        selectedSize.add(ok);
      }

      List<bool> selectedTopping = [];
      tmp = s["toppings"] ?? [];
      for (int i = 0; i < Drink.toppings.length; i++) {
        String id = Drink.toppings[i].id;
        bool ok = false;
        for (int j = 0; j < tmp.length; j++) {
          if ((tmp[j] as String) == id) {
            ok = true;
            break;
          }
        }
        selectedTopping.add(ok);
      }

      drinkList.add(Drink(
          id: doc.id,
          name: s["name"],
          price: s["price"] * 1.0,
          description: s["description"],
          selectedSizes: selectedSize,
          selectedToppings: selectedTopping,
          images: s["images"]));
    });

    emit(LoadedState(
      initFoods: state.initFoods,
      listFood: drinkList,
    ));
  }

  Future<void> _onGoBack(FetchData event, Emitter<DrinkListState> emit) async {
    emit(LoadingState(initFoods: []));

    final pro = await FirebaseFirestore.instance.collection("Food").get();
    List<Drink> drinkList = [];
    pro.docs.forEach((doc) {
      var s = doc.data();
      List<bool> selectedSize = [];
      List<dynamic> tmp = s["sizes"] ?? [];
      for (int i = 0; i < Drink.sizes.length; i++) {
        String id = Drink.sizes[i].id;
        bool ok = false;
        for (int j = 0; j < tmp.length; j++) {
          if ((tmp[j] as String) == id) {
            ok = true;
            break;
          }
        }
        selectedSize.add(ok);
      }

      List<bool> selectedTopping = [];
      tmp = s["toppings"] ?? [];
      for (int i = 0; i < Drink.toppings.length; i++) {
        String id = Drink.toppings[i].id;
        bool ok = false;
        for (int j = 0; j < tmp.length; j++) {
          if ((tmp[j] as String) == id) {
            ok = true;
            break;
          }
        }
        selectedTopping.add(ok);
      }

      drinkList.add(Drink(
          id: doc.id,
          name: s["name"],
          price: s["price"] * 1.0,
          description: s["description"],
          selectedSizes: selectedSize,
          selectedToppings: selectedTopping,
          images: s["images"]));
    });

    emit(LoadedState(
      initFoods: state.initFoods,
      listFood: drinkList,
    ));
  }
}
