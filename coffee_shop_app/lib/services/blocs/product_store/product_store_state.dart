import 'package:coffee_shop_app/services/models/food.dart';

abstract class ProductStoreState {
  final List<Food> initFoods;
  ProductStoreState({required this.initFoods});
}

class LoadingState extends ProductStoreState {
  LoadingState({required super.initFoods});
}

class ErrorState extends ProductStoreState {
  ErrorState({required super.initFoods});
}

abstract class HasDataProductStoreState extends ProductStoreState {
  final List<Food> listFavoriteFood;
  final List<Food> listOtherFood;
  HasDataProductStoreState(
      {required this.listFavoriteFood,
      required this.listOtherFood,
      required super.initFoods});
}

class FetchedState extends HasDataProductStoreState {
  FetchedState(
      {required super.listFavoriteFood,
      required super.listOtherFood,
      required super.initFoods});
}

class LoadedState extends HasDataProductStoreState {
  LoadedState(
      {required super.listFavoriteFood,
      required super.listOtherFood,
      required super.initFoods});
}
