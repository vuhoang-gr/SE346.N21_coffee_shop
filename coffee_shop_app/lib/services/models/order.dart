import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:coffee_shop_app/services/models/store.dart';
import 'order_food.dart';

class Order {
  //TODO: add notes
  String? id;
  Store? store;
  double? discount;
  double? total;
  double? deliveryCost;
  double? totalProduct;
  DateTime dateOrder;
  List<OrderFood> products;
  DeliveryAddress? address;
  String status;
  DateTime? pickupTime;

  Order(
      {this.id,
      this.store,
      this.discount,
      this.total,
      this.deliveryCost,
      this.totalProduct,
      required this.dateOrder,
      required this.products,
      required this.status,
      this.address,
      this.pickupTime});

  Order copyWith(
          {String? id,
          Store? store,
          double? discount,
          double? total,
          double? deliveryCost,
          double? totalProduct,
          DateTime? dateOrder,
          List<OrderFood>? products,
          String? status,
          DeliveryAddress? address,
          DateTime? pickupTime}) =>
      Order(
          dateOrder: dateOrder ?? this.dateOrder,
          products: products ?? this.products,
          id: id ?? this.id,
          store: store ?? this.store,
          discount: discount ?? this.discount,
          total: total ?? this.total,
          totalProduct: totalProduct ?? this.totalProduct,
          deliveryCost: deliveryCost ?? this.deliveryCost,
          status: status ?? this.status,
          address: address ?? this.address,
          pickupTime: pickupTime ?? this.pickupTime);
}
