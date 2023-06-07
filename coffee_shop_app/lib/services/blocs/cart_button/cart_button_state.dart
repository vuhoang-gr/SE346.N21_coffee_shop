import 'package:coffee_shop_app/services/models/delivery_address.dart';

import '../../models/store.dart';
import 'cart_button_event.dart';

class CartButtonState {
  final Store? selectedStore;
  final DeliveryAddress? selectedDeliveryAddress;
  final OrderType selectedOrderType;
  final double distance;
  CartButtonState(
      {required this.selectedStore,
      required this.selectedDeliveryAddress,
      required this.distance,
      this.selectedOrderType = OrderType.delivery});
}
