import 'package:coffee_shop_app/services/models/delivery_address.dart';

abstract class AddressStoreEvent {}

class ListAddressInited extends AddressStoreEvent {}

class ListAddressUpdated extends AddressStoreEvent {
  List<DeliveryAddress> listDeliveryAddress;
  ListAddressUpdated({required this.listDeliveryAddress});
}
