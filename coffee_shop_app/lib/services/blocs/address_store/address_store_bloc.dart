import 'dart:async';

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
  StreamSubscription<List<DeliveryAddress>>? _addressSubscription;
  AddressStoreBloc() : super(LoadedState()) {
    on<FetchData>(_onFetchData);
    on<UpdateIndex>(_onUpdateIndex);
    on<DeleteIndex>(_onDeleteIndex);
    on<Insert>(_onInsert);
    on<UpdateAddresses>(_onUpdateAddresses);
  }

  void _onFetchData(FetchData event, Emitter<AddressStoreState> emit) {
    emit(LoadingState());
    _addressSubscription?.cancel();
    _addressSubscription = AddressAPI()
        .fetchData(AuthAPI.currentUser!.id)
        .listen((listDeliveryAddress) {
      add(UpdateAddresses(listDeliveryAddress: listDeliveryAddress));
    }, onError: (_) {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      add(UpdateAddresses(listDeliveryAddress: []));
    });
  }

  void _onUpdateAddresses(
      UpdateAddresses event, Emitter<AddressStoreState> emit) {
    emit(LoadedState());
  }

  void _onUpdateIndex(
      UpdateIndex event, Emitter<AddressStoreState> emit) async {
    emit(LoadingState());
    _addressSubscription?.pause();
    if (await AddressAPI()
        .update(AuthAPI.currentUser!.id, event.index, event.deliveryAddress)) {
      List<DeliveryAddress> deliveryAddresses = AddressAPI().currentAddresses;
      deliveryAddresses[event.index] = event.deliveryAddress;
      emit(LoadedState());
    } else {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      emit(LoadedState());
    }
    if (_addressSubscription?.isPaused ?? false) {
      _addressSubscription?.resume();
    }
  }

  void _onDeleteIndex(
      DeleteIndex event, Emitter<AddressStoreState> emit) async {
    emit(LoadingState());
    _addressSubscription?.pause();
    if (await AddressAPI().remove(AuthAPI.currentUser!.id, event.index)) {
      List<DeliveryAddress> deliveryAddresses = AddressAPI().currentAddresses;
      deliveryAddresses.removeAt(event.index);
      emit(LoadedState());
    } else {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      emit(LoadedState());
    }
    if (_addressSubscription?.isPaused ?? false) {
      _addressSubscription?.resume();
    }
  }

  void _onInsert(Insert event, Emitter<AddressStoreState> emit) async {
    emit(LoadingState());
    _addressSubscription?.pause();
    if (await AddressAPI()
        .push(AuthAPI.currentUser!.id, event.deliveryAddress)) {
      List<DeliveryAddress> deliveryAddresses = AddressAPI().currentAddresses;
      deliveryAddresses.add(event.deliveryAddress);
      emit(LoadedState());
    } else {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      emit(LoadedState());
    }
    if (_addressSubscription?.isPaused ?? false) {
      _addressSubscription?.resume();
    }
  }

  @override
  Future<void> close() {
    _addressSubscription?.cancel();
    return super.close();
  }
}
