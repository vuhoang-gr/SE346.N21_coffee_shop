import 'package:equatable/equatable.dart';

import '../../models/order.dart';

abstract class OrderListState extends Equatable {
  final List<Order> listDeliveryOrders;
  final List<Order> listPickupOrders;

  final bool isLoaded;
  const OrderListState(
      {required this.listDeliveryOrders,
      this.isLoaded = false,
      required this.listPickupOrders});
}

class OrderNormalState extends OrderListState {
  const OrderNormalState(
      {required List<Order> listDeliveryOrders,
      bool isLoaded = false,
      required List<Order> listPickupOrders})
      : super(
            isLoaded: isLoaded,
            listDeliveryOrders: listDeliveryOrders,
            listPickupOrders: listPickupOrders);
  @override
  // TODO: implement props
  List<Object?> get props => [listDeliveryOrders, listPickupOrders, isLoaded];
}

class OrderHistoryState extends OrderListState {
  const OrderHistoryState(
      {required List<Order> listDeliveryOrders,
      bool isLoaded = false,
      required List<Order> listPickupOrders})
      : super(
            isLoaded: isLoaded,
            listDeliveryOrders: listDeliveryOrders,
            listPickupOrders: listPickupOrders);

  @override
  // TODO: implement props
  List<Object?> get props => [listDeliveryOrders, listPickupOrders, isLoaded];
}
