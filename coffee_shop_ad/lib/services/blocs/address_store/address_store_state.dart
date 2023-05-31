import 'package:coffee_shop_admin/services/models/delivery_address.dart';

abstract class AddressStoreState {
  List<DeliveryAddress> listDeliveryAddress;
  AddressStoreState({required this.listDeliveryAddress});
}

class LoadedState extends AddressStoreState {
  LoadedState({required super.listDeliveryAddress});
}

class LoadingState extends AddressStoreState {
  LoadingState({required super.listDeliveryAddress});
}
