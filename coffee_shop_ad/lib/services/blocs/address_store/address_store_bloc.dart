import 'package:coffee_shop_admin/services/blocs/address_store/address_store_event.dart';
import 'package:coffee_shop_admin/services/blocs/address_store/address_store_state.dart';
import 'package:coffee_shop_admin/services/models/address.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../temp/data.dart';

class AddressStoreBloc extends Bloc<AddressStoreEvent, AddressStoreState> {
  AddressStoreBloc() : super(LoadedState(listDeliveryAddress: [])) {
    on<ListAddressInited>(_onListAddressInited);
    on<ListAddressUpdatedIndex>(_onListAddressUpdatedIndex);
    on<ListAddressDeletedIndex>(_onListAddressDeletedIndex);
    on<ListAddressInserted>(_onListAddressInserted);
  }

  void _onListAddressInited(
      ListAddressInited event, Emitter<AddressStoreState> emit) {
    emit(LoadingState(listDeliveryAddress: []));
    emit(LoadedState(listDeliveryAddress: Data.addresses));
  }

  void _onListAddressUpdatedIndex(
      ListAddressUpdatedIndex event, Emitter<AddressStoreState> emit) {
    emit(LoadingState(listDeliveryAddress: state.listDeliveryAddress));
    List<Address> deliveryAddresses = state.listDeliveryAddress;
    deliveryAddresses[event.index] = event.deliveryAddress;
    emit(LoadedState(listDeliveryAddress: deliveryAddresses));
  }

  void _onListAddressInserted(
      ListAddressInserted event, Emitter<AddressStoreState> emit) {
    emit(LoadingState(listDeliveryAddress: state.listDeliveryAddress));
    List<Address> deliveryAddresses = state.listDeliveryAddress;
    deliveryAddresses.add(event.deliveryAddress);
    emit(LoadedState(listDeliveryAddress: deliveryAddresses));
  }

  void _onListAddressDeletedIndex(
      ListAddressDeletedIndex event, Emitter<AddressStoreState> emit) {
    emit(LoadingState(listDeliveryAddress: state.listDeliveryAddress));
    List<Address> deliveryAddresses = state.listDeliveryAddress;
    deliveryAddresses.removeAt(event.index);
    emit(LoadedState(listDeliveryAddress: deliveryAddresses));
  }
}
