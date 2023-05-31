import 'package:coffee_shop_admin/services/models/cart_food.dart';
import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  //TODO: add notes
  final String? id;
  final double? discount;
  final double? total;
  final double? deliveryCost;
  final List<CartFood> products;

  const Cart({
    this.id,
    this.discount,
    this.total,
    this.deliveryCost,
    required this.products,
  });

  Cart copyWith({
    String? id,
    double? discount,
    double? total,
    double? deliveryCost,
    DateTime? dateOrder,
    List<CartFood>? products,
  }) =>
      Cart(
        products: products ?? this.products,
        id: id ?? this.id,
        discount: discount ?? this.discount,
        total: total ?? this.total,
        deliveryCost: deliveryCost ?? this.deliveryCost,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        products,
        discount,
        total,
        deliveryCost,
      ];
}
