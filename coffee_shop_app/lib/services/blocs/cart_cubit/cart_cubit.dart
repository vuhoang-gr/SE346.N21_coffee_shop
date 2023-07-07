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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/constants/dimension.dart';
import '../../apis/food_api.dart';
import '../../models/food.dart';
import '../../models/cart.dart';
import '../../models/promo.dart';
import '../../models/store.dart';
import '../cart_button/cart_button_bloc.dart';
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
            isLoaded: false)) {
    _productStoreSubscription = productStoreBloc.stream.listen((state) async {
      if (state is product_store_state.FetchedState) {
        await getItemsFromDB();
        checkToppingAvailable();
        checkSizeAvailable();
      }
    });
    _toppingStoreSubscription = toppingStoreBloc.stream.listen((state) {
      if (state is topping_state.FetchedState) {
        checkToppingAvailable();
      }
    });

    _sizeStoreSubscription = sizeStoreBloc.stream.listen((state) {
      if (state is size_state.FetchedState) {
        checkSizeAvailable();
      }
    });

    _userChangedSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        getItemsFromDB();
      }
    });

    CartButtonBloc.changeSelectedStoreSubscription.addListener(storeChange);
  }
  late StreamSubscription _productStoreSubscription;
  late StreamSubscription _toppingStoreSubscription;
  late StreamSubscription _sizeStoreSubscription;
  late StreamSubscription _userChangedSubscription;
  final ProductStoreBloc productStoreBloc;
  final ToppingStoreBloc toppingStoreBloc;
  final SizeStoreBloc sizeStoreBloc;
  bool sizeLoaded = false;
  bool toppingLoaded = false;
  getItemsFromDB() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    final items =
        await SQLHelper.getCartFood(FirebaseAuth.instance.currentUser!.uid);
    List<CartFood> foodList = [];
    for (var item in items) {
      var realFood = FoodAPI()
          .currentFoods
          .where((food) => food.id == (item['foodId'] as String))
          .toList();
      if (realFood.isEmpty) {
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

  String getCartFoodTopping(CartFood cartFood) {
    List<String> toppingNames = [];
    List<String> toppings = cartFood.topping!.split(', ');
    List<String> currentToppingId = [];
    for (var t in ToppingApi().currentToppings) {
      for (var selected in toppings) {
        if (t.id == selected.trim()) {
          if (!cartFood.food.toppings.contains(selected.trim())) {
            return '';
          }
          toppingNames.add(t.name);
          currentToppingId.add(t.id);
        }
      }
    }
    if (toppingNames.length != toppings.length) {
      return '';
    } else {
      return toppingNames.join(', ');
    }
  }

  String getCartFoodSize(CartFood cartFood) {
    var sizes = SizeApi()
        .currentSizes
        .where((size) => size.id == cartFood.size)
        .toList();
    if (!cartFood.food.sizes.contains(cartFood.size) || sizes.isEmpty) {
      return '';
    } else {
      return sizes.first.name;
    }
  }

  setLoading(bool isLoaded) {
    emit(state.copyWith(isLoaded: isLoaded));
  }

  checkToppingAvailable() {
    List<CartFood> newList = [];
    for (var cartFood in state.products) {
      bool isAvailable = true;
      if (getCartFoodTopping(cartFood) == '') {
        isAvailable = false;
      }
      if (cartFood.topping == '') {
        isAvailable = true;
      }
      newList.add(cartFood.copyWith(isToppingAvailable: isAvailable));
    }
    emit(state.copyWith(products: newList));
  }

  checkSizeAvailable() {
    List<CartFood> newList = [];
    for (var cartFood in state.products) {
      bool isAvailable = true;
      if (getCartFoodSize(cartFood) == '') {
        isAvailable = false;
      }
      newList.add(cartFood.copyWith(isSizeAvailable: isAvailable));
    }
    emit(state.copyWith(products: newList));
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
            isSizeAvailable: true,
            isToppingAvailable: true,
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
          isSizeAvailable: true,
          isToppingAvailable: true,
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
      if (item.food.id == cartFood.food.id &&
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
    applyPromoAndCalPrice(state.promo);
  }

  calculateTotalPrice({
    double? discount,
    double? deliveryCost,
  }) {
    double totalFood = 0;
    double total = 0;
    for (var product in state.products) {
      totalFood = totalFood + product.unitPrice * product.quantity;
    }
    deliveryCost ??= state.deliveryCost;
    discount ??= state.discount;
    total = totalFood + deliveryCost! - discount!;
    emit(state.copyWith(
        deliveryCost: deliveryCost,
        discount: discount,
        total: total,
        totalFood: totalFood));
  }

  double calculatePromo(Promo? promo) {
    if (promo == null) {
      return -1;
    }
    if (DateTime.now().isAfter(promo.dateStart) &&
        DateTime.now().isBefore(promo.dateEnd) &&
        (state.totalFood!) >= promo.minPrice) {
      var discount = state.totalFood! * promo.percent;
      if (discount > promo.maxPrice) {
        discount = promo.maxPrice;
      }
      return discount;
    }
    return 0;
  }

  applyPromoAndCalPrice(Promo? promo) {
    var discount = calculatePromo(promo);
    if (discount == -1) {
      emit(state.copyWithNullPromo(discount: 0));
    } else if (discount == 0) {
      if (state.products.isEmpty) {
        return;
      }
      emit(state.copyWithNullPromo(discount: 0));
      Fluttertoast.showToast(
          msg: "Không đủ điều kiện áp dụng mã giảm giá.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
    } else {
      emit(state.copyWith(promo: promo, discount: discount));
      calculateTotalPrice();
    }
  }

  void checkPromo(Object? value, Store store) {
    if (value != null && value is Promo) {
      String? idSelectedStore = store.id;
      if (value.stores.contains(idSelectedStore)) {
        if (!value.forNewCustomer) {
          applyPromoAndCalPrice(value);
        } else {
          if (AuthAPI.currentUser != null) {
            if (AuthAPI.currentUser!.createDate
                .isAfter(DateTime.now().add(Duration(days: -7)))) {
              applyPromoAndCalPrice(value);
              return;
            }
          }
          Fluttertoast.showToast(
              msg: "Mã giảm giá chỉ áp dụng cho người dùng mới",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: Dimension.font14);
        }
      } else {
        applyPromoAndCalPrice(null);
        Fluttertoast.showToast(
            msg: "Mã giảm giá không thể áp dụng ở cửa hàng được chọn",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: Dimension.font14);
      }
    }
  }

  double calcualteUnitPrice(Food food, String size, String? topping) {
    double unitPrice = food.price;
    for (var s in SizeApi().currentSizes) {
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

  bool checkCanOrderFoods({
    required Store store,
  }) {
    List<CartFood> newList = [];
    for (var pr in state.products) {
      bool isSize = pr.isSizeAvailable;
      bool isTopping = pr.isToppingAvailable;
      if (store.stateFood[pr.food.id] != null) {
        if (store.stateFood[pr.food.id]!.contains(pr.size)) {
          isSize = false;
        }
      }
      if (pr.topping != null && pr.topping != '') {
        for (var tp in store.stateTopping) {
          if (pr.topping!.contains(tp)) {
            isTopping = false;
            break;
          }
        }
      }
      newList.add(
          pr.copyWith(isSizeAvailable: isSize, isToppingAvailable: isTopping));
    }
    emit(state.copyWith(products: newList));
    return state.products
        .where((element) =>
            !element.isSizeAvailable ||
            !element.isToppingAvailable ||
            !element.food.isAvailable)
        .isEmpty;
  }

  Future<void> placeOrder(
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

  storeChange() {
    checkPromo(
        state.promo, CartButtonBloc.changeSelectedStoreSubscription.value!);
  }

  @override
  Future<void> close() {
    _productStoreSubscription.cancel();
    _sizeStoreSubscription.cancel();
    _toppingStoreSubscription.cancel();
    _userChangedSubscription.cancel();
    CartButtonBloc.changeSelectedStoreSubscription.removeListener(storeChange);

    return super.close();
  }
}
