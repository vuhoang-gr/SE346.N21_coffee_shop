import 'package:coffee_shop_admin/services/models/address.dart';

abstract class AddressStoreEvent {}

class ListAddressInited extends AddressStoreEvent {}

class ListAddressUpdatedIndex extends AddressStoreEvent {
  Address deliveryAddress;
  int index;
  ListAddressUpdatedIndex({required this.deliveryAddress, required this.index});
}

class ListAddressDeletedIndex extends AddressStoreEvent {
  int index;
  ListAddressDeletedIndex({required this.index});
}

class ListAddressInserted extends AddressStoreEvent {
  Address deliveryAddress;
  ListAddressInserted({required this.deliveryAddress});
}
