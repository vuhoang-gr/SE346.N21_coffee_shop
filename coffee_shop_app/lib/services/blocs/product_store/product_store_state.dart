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

class LoadedState extends ProductStoreState {
  final List<Food> listFavoriteFood;
  final List<Food> listOtherFood;
  LoadedState(
      {required super.initFoods,
      required this.listFavoriteFood,
      required this.listOtherFood});
}
