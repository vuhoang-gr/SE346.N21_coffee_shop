import 'package:coffee_shop_admin/services/models/topping.dart';

abstract class ToppingListState {
  ToppingListState();
}

class LoadingState extends ToppingListState {
  LoadingState();
}

class ErrorState extends ToppingListState {
  ErrorState();
}

class LoadedState extends ToppingListState {
  final List<Topping> toppingList;
  LoadedState({required this.toppingList});
}
