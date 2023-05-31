import 'package:coffee_shop_admin/services/models/drink.dart';

abstract class DrinkListState {
  final List<Drink> initFoods;
  DrinkListState({required this.initFoods});
}

class LoadingState extends DrinkListState {
  LoadingState({required super.initFoods});
}

class ErrorState extends DrinkListState {
  ErrorState({required super.initFoods});
}

class LoadedState extends DrinkListState {
  final List<Drink> listFood;
  LoadedState({required super.initFoods, required this.listFood});
}
