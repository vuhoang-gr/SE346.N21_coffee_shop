import 'package:coffee_shop_admin/services/models/drink.dart';

abstract class DrinkListEvent {}

class FetchData extends DrinkListEvent {}

class UpdateFavorite extends DrinkListEvent {
  final Drink food;
  UpdateFavorite({required this.food});
}
