import 'package:coffee_shop_admin/services/models/drink.dart';

abstract class ToppingListEvent {}

class FetchData extends ToppingListEvent {}

class UpdateFavorite extends ToppingListEvent {
  final Drink food;
  UpdateFavorite({required this.food});
}
