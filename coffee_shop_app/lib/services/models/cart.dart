import 'package:coffee_shop_app/services/models/cart_food.dart';
import 'package:coffee_shop_app/services/models/promo.dart';
import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final String? id;
  final double? discount;
  final double? total;
  final double? totalFood;
  final double? deliveryCost;
  final List<CartFood> products;
  final Promo? promo;
  final bool isLoaded;
  const Cart(
      {this.id,
      this.discount,
      this.total,
      this.deliveryCost,
      this.totalFood,
      this.promo,
      required this.products,
      required this.isLoaded});

  Cart copyWith(
          {String? id,
          double? discount,
          double? total,
          double? totalFood,
          double? deliveryCost,
          DateTime? dateOrder,
          List<CartFood>? products,
          List<int>? cannotOrderFoods,
          Promo? promo,
          bool? isLoaded}) =>
      Cart(
          products: products ?? this.products,
          id: id ?? this.id,
          discount: discount ?? this.discount,
          total: total ?? this.total,
          totalFood: totalFood ?? this.totalFood,
          deliveryCost: deliveryCost ?? this.deliveryCost,
          promo: promo ?? this.promo,
          isLoaded: isLoaded ?? this.isLoaded);

  @override
  // TODO: implement props
  List<Object?> get props => [
        products,
        discount,
        total,
        deliveryCost,
        totalFood,
        promo,
      ];
}
