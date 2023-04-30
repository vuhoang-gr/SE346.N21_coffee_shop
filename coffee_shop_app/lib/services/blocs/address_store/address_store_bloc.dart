import 'package:coffee_shop_app/services/blocs/address_store/address_store_event.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../temp/data.dart';

class AddressStoreBloc extends Bloc<AddressStoreEvent, AddressStoreState> {
  AddressStoreBloc() : super(LoadedState(listDeliveryAddress: [])) {
    on<ListAddressInited>(_onListAddressInited);
    on<ListAddressUpdated>(_onListAddressUpdated);
  }

  void _onListAddressInited(
      ListAddressInited event, Emitter<AddressStoreState> emit) {
    emit(LoadingState());
    emit(LoadedState(listDeliveryAddress: Data.addresses));
  }

  void _onListAddressUpdated(
      ListAddressUpdated event, Emitter<AddressStoreState> emit) {
    emit(LoadingState());
    emit(LoadedState(listDeliveryAddress: event.listDeliveryAddress));
  }
}
