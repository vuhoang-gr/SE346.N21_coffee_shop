import 'package:coffee_shop_app/services/models/cart_food.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/food.dart';
import '../../models/cart.dart';

class CartCubit extends Cubit<Cart> {
  CartCubit()
      : super(Cart(
          products: [],
          total: 0,
          deliveryCost: 0,
          discount: 0,
        ));

  addProduct(Food food, int quantity, String sizeId, String? topping,
      double unitPrice, String? note) {
    bool isAdded = false;
    List<CartFood> newFoodList = [];
    for (var item in state.products) {
      if (item.food.id == food.id &&
          item.size == sizeId &&
          item.topping == topping) {
        isAdded = true;
        newFoodList.add(CartFood(
            food: food,
            quantity: item.quantity + quantity,
            size: sizeId,
            topping: topping,
            unitPrice: unitPrice,
            note: note));
      } else {
        newFoodList.add(item.copyWith());
      }
    }

    if (!isAdded) {
      newFoodList.add(CartFood(
          food: food,
          quantity: quantity,
          size: sizeId,
          topping: topping,
          unitPrice: unitPrice,
          note: note));
    }

    emit(state.copyWith(products: newFoodList));
    calculateTotalPrice();
  }

  updateQuantityFromCart(CartFood cartFood, int totalQuantity) {
    List<CartFood> newFoodList = [];
    for (var item in state.products) {
      if (item.food.id == cartFood.food.id &&
          item.size == cartFood.size &&
          item.topping == cartFood.topping) {
        if (totalQuantity == 0) {
          continue;
        }
        newFoodList.add(item.copyWith(quantity: totalQuantity));
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
    double total = 0;
    for (var product in state.products) {
      total = total + product.unitPrice * product.quantity;
    }

    total = total + deliveryCost - discount;
    emit(state.copyWith(
        deliveryCost: deliveryCost, discount: discount, total: total));
  }
}
