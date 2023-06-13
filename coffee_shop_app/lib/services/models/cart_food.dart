import 'package:coffee_shop_app/services/models/food.dart';
import 'package:equatable/equatable.dart';

import '../apis/auth_api.dart';
import '../apis/food_api.dart';

class CartFood extends Equatable {
  // unit price including price of one drink, size price, topping price
  // size is the size id
  final int id;
  final Food food;
  final int quantity;
  final String size;
  final String? topping;
  final String? note;
  final double unitPrice;
  final bool isToppingAvailable;
  final bool isSizeAvailable;
  const CartFood(
      {required this.id,
      required this.food,
      required this.quantity,
      required this.size,
      this.topping,
      this.note,
      required this.unitPrice,
      required this.isSizeAvailable,
      required this.isToppingAvailable});
  CartFood copyWith({
    int? id,
    Food? food,
    int? quantity,
    String? size,
    String? topping,
    String? note,
    double? unitPrice,
    bool? isToppingAvailable,
    bool? isSizeAvailable,
  }) =>
      CartFood(
          id: id ?? this.id,
          food: food ?? this.food,
          quantity: quantity ?? this.quantity,
          size: size ?? this.size,
          topping: topping ?? this.topping,
          note: note ?? this.note,
          unitPrice: unitPrice ?? this.unitPrice,
          isSizeAvailable: isSizeAvailable ?? this.isSizeAvailable,
          isToppingAvailable: isToppingAvailable ?? this.isToppingAvailable);
  @override
  // TODO: implement props
  List<Object?> get props => [
        food,
        quantity,
        size,
        topping,
        note,
        isToppingAvailable,
        isSizeAvailable
      ];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userId': AuthAPI.currentUser!.id,
      'foodId': food.id,
      'quantity': quantity,
      'size': size,
      'topping': topping,
      'note': note,
    };
    return map;
  }

//TODO: check unit price
  CartFood.fromMap(Map<String, dynamic> map)
      : quantity = map['quantity'] as int,
        size = map['size'] as String,
        topping = map['topping'] as String?,
        note = map['note'] as String?,
        food = FoodAPI().currentFoods.firstWhere(
              (food) => food.id == (map['foodId'] as String),
            ),
        unitPrice = 0,
        isToppingAvailable = true,
        isSizeAvailable = true,
        id = map['id'] as int;
}
