import 'package:coffee_shop_app/services/models/store.dart';
import 'package:equatable/equatable.dart';

import 'address.dart';
import 'cart_food.dart';

class Order extends Equatable {
  //TODO: add notes
  final String? id;
  final Store? store; //TODO: store is required
  final int? discount;
  final int? total;
  final int? deliveryCost;
  final DateTime dateOrder;
  final List<CartFood> products;
  final Address? address;
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
      this.address,
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
          Address? address,
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
          address: address ?? this.address,
          pickupTime: pickupTime ?? this.pickupTime);

  @override
  // TODO: implement props
  List<Object?> get props => [
        products,
        store,
        discount,
        total,
        deliveryCost,
        dateOrder,
        address,
        status,
        pickupTime
      ];
}
