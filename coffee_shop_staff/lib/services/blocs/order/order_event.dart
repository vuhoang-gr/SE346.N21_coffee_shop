part of 'order_bloc.dart';

@immutable
abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadOrder extends OrderEvent {}

class ChangeOrder extends OrderEvent {
  final Order order;
  ChangeOrder({required this.order});
  @override
  List<Object?> get props => [order];
}
