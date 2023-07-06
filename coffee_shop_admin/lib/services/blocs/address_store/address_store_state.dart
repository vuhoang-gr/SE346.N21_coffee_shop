import 'package:coffee_shop_admin/services/models/address.dart';

abstract class AddressStoreState {
  List<Address> listDeliveryAddress;
  AddressStoreState({required this.listDeliveryAddress});
}

class LoadedState extends AddressStoreState {
  LoadedState({required super.listDeliveryAddress});
}

class LoadingState extends AddressStoreState {
  LoadingState({required super.listDeliveryAddress});
}
