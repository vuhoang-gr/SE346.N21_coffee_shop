part of 'order_bloc.dart';

@immutable
abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Order> pickup;
  final List<Order> delivery;
  OrderLoaded({required this.pickup, required this.delivery});
  @override
  List<Object?> get props => [pickup, delivery];
}
