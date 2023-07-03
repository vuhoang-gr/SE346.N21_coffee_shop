import 'package:coffee_shop_admin/services/models/store.dart';
import 'package:equatable/equatable.dart';

import 'cart_food.dart';

class Order extends Equatable {
  final String? id;
  final Store? store;
  final int? discount;
  final int? total;
  final int? deliveryCost;
  final DateTime dateOrder;
  final List<CartFood> products;
  final String? status;
  final DateTime? pickupTime;

  const Order(
      {this.id,
      this.store,
      this.discount,
      this.total,
      this.deliveryCost,
      required this.dateOrder,
      required this.products,
      this.status,
      this.pickupTime});

  Order copyWith(
          {String? id,
          Store? store,
          int? discount,
          int? total,
          int? deliveryCost,
          DateTime? dateOrder,
          List<CartFood>? products,
          String? status,
          DateTime? pickupTime}) =>
      Order(
          dateOrder: dateOrder ?? this.dateOrder,
          products: products ?? this.products,
          id: id ?? this.id,
          store: store ?? this.store,
          discount: discount ?? this.discount,
          total: total ?? this.total,
          deliveryCost: deliveryCost ?? this.deliveryCost,
          status: status ?? this.status,
          pickupTime: pickupTime ?? this.pickupTime);

  @override
  List<Object?> get props => [
        products,
        store,
        discount,
        total,
        deliveryCost,
        dateOrder,
        status,
        pickupTime
      ];
}
