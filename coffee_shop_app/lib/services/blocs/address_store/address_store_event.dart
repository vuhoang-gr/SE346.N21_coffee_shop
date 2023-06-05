import 'package:coffee_shop_app/services/models/delivery_address.dart';

abstract class AddressStoreEvent {}

class FetchData extends AddressStoreEvent {}

class UpdateIndex extends AddressStoreEvent {
  DeliveryAddress deliveryAddress;
  int index;
  UpdateIndex({required this.deliveryAddress, required this.index});
}

class DeleteIndex extends AddressStoreEvent {
  int index;
  DeleteIndex({required this.index});
}

class Insert extends AddressStoreEvent {
  DeliveryAddress deliveryAddress;
  Insert({required this.deliveryAddress});
}

class UpdateAddresses extends AddressStoreEvent {
  List<DeliveryAddress> listDeliveryAddress;
  UpdateAddresses({required this.listDeliveryAddress});
}
