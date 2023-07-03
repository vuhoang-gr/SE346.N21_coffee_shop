part of 'product_bloc.dart';

@immutable
abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  final String shopID;
  ProductLoading({required this.shopID});
  @override
  List<Object?> get props => [shopID];
}

class ProductLoaded extends ProductState {
  final List<StoreProduct> topping;
  final List<FoodChecker> drink;
  ProductLoaded({required this.topping, required this.drink});
  @override
  List<Object?> get props => [topping, drink];
}
