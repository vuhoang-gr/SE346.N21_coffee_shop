import 'package:coffee_shop_app/services/models/food.dart';

abstract class ProductStoreState {}

class LoadingState extends ProductStoreState {
  LoadingState();
}

class ErrorState extends ProductStoreState {
  ErrorState();
}

class FetchedState extends ProductStoreState {
  final List<Food> initFoods;
  FetchedState(
      {required this.initFoods});
}

class LoadedState extends ProductStoreState {
  final List<Food> initFoods;
  final List<Food> listFavoriteFood;
  final List<Food> listOtherFood;
  LoadedState(
      {required this.initFoods,
      required this.listFavoriteFood,
      required this.listOtherFood});
}
