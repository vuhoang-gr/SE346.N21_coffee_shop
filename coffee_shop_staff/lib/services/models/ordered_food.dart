import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class OrderedFood extends Equatable {
  String? id;
  String image;
  String name;
  int amount;
  String size;
  String? topping;
  String? note;
  double unitPrice;
  double totalPrice;
  OrderedFood(
      {required this.name,
      this.id,
      required this.amount,
      required this.size,
      required this.image,
      this.topping,
      this.note,
      required this.unitPrice,
      required this.totalPrice});

  @override
  List<Object?> get props => [id, name, amount, topping, size, note];
}
