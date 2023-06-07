import 'package:coffee_shop_app/services/models/food.dart';

abstract class ProductStoreState {}

class LoadingState extends ProductStoreState {}

class ErrorState extends ProductStoreState {}

abstract class HasDataProductStoreState extends ProductStoreState {
  final List<Food> listFavoriteFood;
  final List<Food> listOtherFood;
  HasDataProductStoreState(
      {required this.listFavoriteFood, required this.listOtherFood});
}

class FetchedState extends HasDataProductStoreState {
  FetchedState({required super.listFavoriteFood, required super.listOtherFood});
}

class LoadedState extends HasDataProductStoreState {
  LoadedState({required super.listFavoriteFood, required super.listOtherFood});
}
