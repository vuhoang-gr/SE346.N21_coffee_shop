import 'package:coffee_shop_app/services/models/food.dart';

abstract class ProductStoreEvent {}

class FetchData extends ProductStoreEvent {
  Map<String, List<String>>? stateFood;
  FetchData({this.stateFood});
}

class UpdateFavorite extends ProductStoreEvent {
  final Food food;
  UpdateFavorite({required this.food});
}

class GetDataFetched extends ProductStoreEvent {
  final List<Food> listFoods;
  GetDataFetched({required this.listFoods});
}
