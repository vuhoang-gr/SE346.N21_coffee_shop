import 'package:coffee_shop_app/services/models/food.dart';
import 'package:equatable/equatable.dart';

class CartFood extends Equatable {
  final Food food;
  final int quantity;
  final String size;
  final String? topping;
  final String? note;
  final double unitPrice;
  const CartFood({
    required this.food,
    required this.quantity,
    required this.size,
    this.topping,
    this.note,
    required this.unitPrice,
  });
  CartFood copyWith({
    Food? food,
    int? quantity,
    String? size,
    String? topping,
    String? note,
    double? unitPrice,
  }) =>
      CartFood(
        food: food ?? this.food,
        quantity: quantity ?? this.quantity,
        size: size ?? this.size,
        topping: topping ?? this.topping,
        note: note ?? this.note,
        unitPrice: unitPrice ?? this.unitPrice,
      );
  @override
  // TODO: implement props
  List<Object?> get props => [food, quantity, size, topping, note];
}
