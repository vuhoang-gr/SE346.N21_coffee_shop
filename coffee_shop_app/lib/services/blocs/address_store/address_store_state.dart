import 'package:coffee_shop_app/services/models/delivery_address.dart';

abstract class AddressStoreState{}

class LoadedState extends AddressStoreState {
  List<DeliveryAddress> listDeliveryAddress;
  LoadedState({
    required this.listDeliveryAddress
  }); 
}

class LoadingState extends AddressStoreState {
  LoadingState(); 
}
