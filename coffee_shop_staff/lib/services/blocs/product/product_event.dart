part of 'product_bloc.dart';

@immutable
abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProduct extends ProductEvent {
  final String storeID;
  LoadProduct({required this.storeID});
  @override
  List<Object?> get props => [storeID];
}

class ChangeProduct extends ProductEvent {
  final List<FoodChecker> product;
  ChangeProduct({required this.product});
  @override
  List<Object?> get props => [product];
}
