import 'package:coffee_shop_admin/services/models/topping.dart';
import 'package:equatable/equatable.dart';

import 'food.dart';
import 'size.dart';

class OrderedFood extends Equatable {
  Food food;
  int amount;
  List<Topping>? toppings;
  late double unitPrice;
  late double totalPrice;
  Size size;
  String? note;

  OrderedFood({
    required this.food,
    required this.amount,
    required this.size,
    this.toppings,
    this.note,
  }) {
    unitPrice = food.price + size.price;
    if (toppings != null) {
      for (var item in toppings!) {
        unitPrice += item.price;
      }
    }
    totalPrice = unitPrice * amount;
  }

  @override
  List<Object?> get props => [food, amount, toppings, note];
}
