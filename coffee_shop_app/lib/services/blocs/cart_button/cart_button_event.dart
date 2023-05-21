import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:coffee_shop_app/services/models/store.dart';

abstract class CartButtonEvent {}

class ChangeSelectedStore extends CartButtonEvent {
  final Store selectedStore;

  ChangeSelectedStore({required this.selectedStore});
}

class ChangeSelectedStoreButNotUse extends CartButtonEvent {
  final Store selectedStore;

  ChangeSelectedStoreButNotUse({required this.selectedStore});
}

class ChangeSelectedDeliveryAddress extends CartButtonEvent {
  final DeliveryAddress selectedDeliveryAddress;

  ChangeSelectedDeliveryAddress({required this.selectedDeliveryAddress});
}

class ChangeSelectedOrderType extends CartButtonEvent {
  final OrderType selectedOrderType;

  ChangeSelectedOrderType({required this.selectedOrderType});
}

enum OrderType {
  delivery,
  storePickup,
}
