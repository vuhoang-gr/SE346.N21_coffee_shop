import 'package:coffee_shop_app/services/apis/address_api.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_event.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_state.dart';
import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/constants/dimension.dart';
import '../../apis/auth_api.dart';

class AddressStoreBloc extends Bloc<AddressStoreEvent, AddressStoreState> {
  AddressStoreBloc() : super(LoadedState(listDeliveryAddress: [])) {
    on<FetchData>(_onListAddressInited);
    on<UpdateIndex>(_onListAddressUpdatedIndex);
    on<DeleteIndex>(_onListAddressDeletedIndex);
    on<Insert>(_onListAddressInserted);
  }

  void _onListAddressInited(
      FetchData event, Emitter<AddressStoreState> emit) async {
    emit(LoadingState(listDeliveryAddress: []));
    List<DeliveryAddress> fetchedData =
        await AddressAPI().fetchData(AuthAPI.currentUser!.id);
    emit(LoadedState(listDeliveryAddress: fetchedData));
  }

  void _onListAddressUpdatedIndex(
      UpdateIndex event, Emitter<AddressStoreState> emit) async {
    emit(LoadingState(listDeliveryAddress: state.listDeliveryAddress));
    if (await AddressAPI()
        .update(AuthAPI.currentUser!.id, event.index, event.deliveryAddress)) {
      List<DeliveryAddress> deliveryAddresses = state.listDeliveryAddress;
      deliveryAddresses[event.index] = event.deliveryAddress;
      emit(LoadedState(listDeliveryAddress: deliveryAddresses));
    } else {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      emit(LoadedState(listDeliveryAddress: state.listDeliveryAddress));
    }
  }

  void _onListAddressInserted(
      Insert event, Emitter<AddressStoreState> emit) async {
    emit(LoadingState(listDeliveryAddress: state.listDeliveryAddress));
    if (await AddressAPI()
        .push(AuthAPI.currentUser!.id, event.deliveryAddress)) {
      List<DeliveryAddress> deliveryAddresses = state.listDeliveryAddress;
      deliveryAddresses.add(event.deliveryAddress);
      emit(LoadedState(listDeliveryAddress: deliveryAddresses));
    } else {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      emit(LoadedState(listDeliveryAddress: state.listDeliveryAddress));
    }
  }

  void _onListAddressDeletedIndex(
      DeleteIndex event, Emitter<AddressStoreState> emit) async {
    emit(LoadingState(listDeliveryAddress: state.listDeliveryAddress));
    if (await AddressAPI().remove(AuthAPI.currentUser!.id, event.index)) {
      List<DeliveryAddress> deliveryAddresses = state.listDeliveryAddress;
      deliveryAddresses.removeAt(event.index);
      emit(LoadedState(listDeliveryAddress: deliveryAddresses));
    } else {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      emit(LoadedState(listDeliveryAddress: state.listDeliveryAddress));
    }
  }
}
