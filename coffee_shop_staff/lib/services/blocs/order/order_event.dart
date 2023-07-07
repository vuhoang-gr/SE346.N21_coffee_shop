part of 'order_bloc.dart';

@immutable
abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchOrder extends OrderEvent {}

class LoadOrder extends OrderEvent {
  final List<Order> deli;
  final List<Order> pickup;
  LoadOrder({required this.deli, required this.pickup});
  @override
  List<Object?> get props => [deli, pickup];
}

class ChangeOrder extends OrderEvent {
  final Order order;
  ChangeOrder({required this.order});
  @override
  List<Object?> get props => [order];
}

class UpdateOrderList extends OrderEvent {
  final List<Order> orderList;
  UpdateOrderList({required this.orderList});
  @override
  List<Object?> get props => [orderList];
}
