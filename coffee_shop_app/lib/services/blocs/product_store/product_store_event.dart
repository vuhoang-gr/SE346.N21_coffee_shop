import 'package:coffee_shop_app/services/models/food.dart';

abstract class ProductStoreEvent {}

class FetchData extends ProductStoreEvent {
  Map<String, List<String>>? stateFood;
  List<String>? stateTopping;
  FetchData({this.stateFood, this.stateTopping});
}

class UpdateFavorite extends ProductStoreEvent {
  final Food food;
  UpdateFavorite({required this.food});
}

class ChangeFetchedToLoaded extends ProductStoreEvent {
  ChangeFetchedToLoaded();
}

