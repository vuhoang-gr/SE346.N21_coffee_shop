import 'dart:async';

import 'package:coffee_shop_app/services/apis/auth_api.dart';
import 'package:coffee_shop_app/services/apis/order_api.dart';
import 'package:coffee_shop_app/services/apis/size_api.dart';
import 'package:coffee_shop_app/services/apis/topping_api.dart';
import 'package:coffee_shop_app/services/blocs/size_store/size_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/topping_store/topping_store_bloc.dart';
import 'package:coffee_shop_app/services/models/cart_food.dart';
import 'package:coffee_shop_app/services/apis/sql_helper.dart';
import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apis/food_api.dart';
import '../../models/food.dart';
import '../../models/cart.dart';
import '../../models/store.dart';
import '../product_store/product_store_bloc.dart';

import 'package:coffee_shop_app/services/blocs/product_store/product_store_state.dart'
    as product_store_state;
import 'package:coffee_shop_app/services/blocs/size_store/size_store_state.dart'
    as size_state;
import 'package:coffee_shop_app/services/blocs/topping_store/topping_store_state.dart'
    as topping_state;

class CartCubit extends Cubit<Cart> {
  CartCubit(
      {required this.productStoreBloc,
      required this.toppingStoreBloc,
      required this.sizeStoreBloc})
      : super(Cart(
            products: [],
            total: 0,
            deliveryCost: 0,
            discount: 0,
            totalFood: 0,
            cannotOrderFoods: [],
            isLoaded: false)) {
    print("stateInit: carCubit............................................");
    _productStoreSubscription = productStoreBloc.stream.listen((state) async {
      if (state is product_store_state.FetchedState) {
        await getItemsFromDB();
      }
    });
    _toppingStoreSubscription = toppingStoreBloc.stream.listen((state) {
      if (state is topping_state.FetchedState) {
        toppingLoaded = true;
        setLoading(sizeLoaded && toppingLoaded);
      }
    });

    _sizeStoreSubscription = sizeStoreBloc.stream.listen((state) {
      if (state is size_state.FetchedState) {
        sizeLoaded = true;
        setLoading(sizeLoaded && toppingLoaded);
      }
    });
  }
  late StreamSubscription _productStoreSubscription;
  late StreamSubscription _toppingStoreSubscription;
  late StreamSubscription _sizeStoreSubscription;
  final ProductStoreBloc productStoreBloc;
  final ToppingStoreBloc toppingStoreBloc;
  final SizeStoreBloc sizeStoreBloc;
  bool sizeLoaded = false;
  bool toppingLoaded = false;
  getItemsFromDB() async {
    final items = await SQLHelper.getCartFood(AuthAPI.currentUser!.id);
    List<CartFood> foodList = [];
    for (var item in items) {
      if (FoodAPI()
          .currentFoods
          .where((food) => food.id == (item['foodId'] as String))
          .isEmpty) {
        continue;
      }
      var cartFood = CartFood.fromMap(item);
      foodList.add(cartFood.copyWith(
          unitPrice: calcualteUnitPrice(
              cartFood.food, cartFood.size, cartFood.topping)));
    }

    emit(state.copyWith(products: foodList, isLoaded: true));
    calculateTotalPrice();
  }

  setLoading(bool isLoaded) {
    emit(state.copyWith(isLoaded: isLoaded));
  }

  addProduct(Food food, int quantity, String sizeId, String? topping,
      double unitPrice, String? note) async {
    bool isAdded = false;
    List<CartFood> newFoodList = [];
    for (var item in state.products) {
      if (item.food.id == food.id &&
          item.size == sizeId &&
          item.topping == topping) {
        isAdded = true;

        final newFood = CartFood(
            id: 0,
            food: food,
            quantity: item.quantity + quantity,
            size: sizeId,
            topping: topping,
            unitPrice: unitPrice,
            note: note);
        int id = await SQLHelper.updateCartFood(newFood);
        newFoodList.add(newFood.copyWith(id: id));
      } else {
        newFoodList.add(item.copyWith());
      }
    }

    if (!isAdded) {
      final newFood = CartFood(
          id: 0,
          food: food,
          quantity: quantity,
          size: sizeId,
          topping: topping,
          unitPrice: unitPrice,
          note: note);
      int id = await SQLHelper.createCartFood(newFood);
      newFoodList.add(newFood.copyWith(id: id));
    }

    emit(state.copyWith(products: newFoodList));
    calculateTotalPrice();
  }

  updateQuantityFromCart(CartFood cartFood, int totalQuantity) async {
    List<CartFood> newFoodList = [];
    for (var item in state.products) {
      if (item.food!.id == cartFood.food!.id &&
          item.size == cartFood.size &&
          item.topping == cartFood.topping) {
        if (totalQuantity == 0) {
          await SQLHelper.deleteCartFood(cartFood.id);
          continue;
        }
        newFoodList.add(item.copyWith(quantity: totalQuantity));
        await SQLHelper.updateCartFood(item.copyWith(quantity: totalQuantity));
      } else {
        newFoodList.add(item.copyWith());
      }
    }

    emit(state.copyWith(products: newFoodList));
    calculateTotalPrice();
  }

  calculateTotalPrice({
    double discount = 0,
    double deliveryCost = 0,
  }) {
    double totalFood = 0;
    double total = 0;
    for (var product in state.products) {
      totalFood = totalFood + product.unitPrice * product.quantity;
    }
    total = totalFood + deliveryCost - discount;
    emit(state.copyWith(
        deliveryCost: deliveryCost,
        discount: discount,
        total: total,
        totalFood: totalFood));
  }

  double calcualteUnitPrice(Food food, String size, String? topping) {
    double unitPrice = food.price;
    for (var s in SizeApi().currentSizes!) {
      if (size == s.id) {
        unitPrice += s.price;
        break;
      }
    }

    if (topping == null || topping == "") return unitPrice;
    List<String> toppings = topping.split(',');
    for (var t in ToppingApi().currentToppings) {
      for (var selected in toppings) {
        if (selected.trim() == t.id) {
          unitPrice += t.price;
        }
      }
    }
    return unitPrice;
  }

  // addPromo(Promo promo){
  //   emit(state.copyWith(discount: ))
  // }

  bool checkCanOrderFoods(
      {required Store store,
      DeliveryAddress? address,
      DateTime? pickupTime,
      String? status}) {
    List<String> list = [];
    for (var pr in state.products) {
      if (!pr.food.isAvailable) {
        list.add(pr.food.id);
      }
      if (store.stateFood[pr] != null) {
        list.add(pr.food.id);
      }

      if (pr.topping != null && pr.topping != '') {
        for (var tp in store.stateTopping) {
          if (pr.topping!.contains(tp)) {
            list.add(pr.food.id);
            break;
          }
        }
      }
    }
    emit(state.copyWith(cannotOrderFoods: list));
    if (list.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  placeOrder(
      {required Store store,
      DeliveryAddress? address,
      DateTime? pickupTime,
      String? status}) async {
    await OrderAPI().addOrder(OrderAPI().fromCart(
        cart: state,
        store: store,
        address: address,
        pickupTime: pickupTime,
        status: status ?? 'Đang xử lí'));

    for (var cartFood in state.products) {
      await SQLHelper.deleteCartFood(cartFood.id);
    }
    await getItemsFromDB();
  }

  @override
  Future<void> close() {
    _productStoreSubscription.cancel();
    _sizeStoreSubscription.cancel();
    _toppingStoreSubscription.cancel();
    return super.close();
  }
}
