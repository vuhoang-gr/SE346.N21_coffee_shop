import 'package:coffee_shop_admin/services/models/drink.dart';

abstract class ToppingListState {
  final List<Drink> initFoods;
  ToppingListState({required this.initFoods});
}

class LoadingState extends ToppingListState {
  LoadingState({required super.initFoods});
}

class ErrorState extends ToppingListState {
  ErrorState({required super.initFoods});
}

class LoadedState extends ToppingListState {
  final List<Drink> listFood;
  LoadedState({required super.initFoods, required this.listFood});
}
