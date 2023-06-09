import 'package:coffee_shop_staff/services/models/delivery_address.dart';
import 'package:coffee_shop_staff/services/models/ordered_food.dart';
import 'package:coffee_shop_staff/services/models/store.dart';
import 'package:coffee_shop_staff/services/models/user.dart';
import 'package:coffee_shop_staff/utils/constants/order_enum.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Order extends Equatable {
  final String id;
  User user;
  Store store;
  double? discount;
  double? deliveryFee;
  double totalPrice;
  DateTime? pickupTime;
  DateTime orderDate;
  List<OrderedFood> productList;
  DeliveryAddress? deliveryAddress;
  late OrderStatus status;
  late bool isPickup;

  Order({
    required this.id,
    required this.user,
    required this.store,
    this.discount = 0,
    this.deliveryFee = 0,
    this.pickupTime,
    required this.orderDate,
    required this.productList,
    this.deliveryAddress,
    this.totalPrice = -1,
    OrderStatus? status,
  }) {
    this.status = status ?? OrderStatus.preparing;

    if (pickupTime != null) {
      isPickup = true;
    } else {
      isPickup = false;
    }
  }

  @override
  List<Object?> get props => [id];
}
