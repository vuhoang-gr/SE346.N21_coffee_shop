import 'package:coffee_shop_app/services/models/topping.dart';

abstract class ToppingStoreEvent {}

class FetchData extends ToppingStoreEvent {}

class GetDataFetched extends ToppingStoreEvent {
  final List<Topping> listToppings;
  GetDataFetched({required this.listToppings});
}
