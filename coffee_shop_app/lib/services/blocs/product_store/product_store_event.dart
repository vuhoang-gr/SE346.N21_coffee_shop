import 'package:coffee_shop_app/services/models/food.dart';

abstract class ProductStoreEvent {}

class FetchData extends ProductStoreEvent {}

class UpdateFavorite extends ProductStoreEvent {
  final Food food;
  UpdateFavorite({required this.food});
}
