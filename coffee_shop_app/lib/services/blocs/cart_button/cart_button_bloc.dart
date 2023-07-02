import 'package:coffee_shop_app/main.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_state.dart';
import 'package:coffee_shop_app/services/functions/calculate_distance.dart';
import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:coffee_shop_app/services/models/location.dart';
import 'package:coffee_shop_app/services/models/store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CartButtonBloc extends Bloc<CartButtonEvent, CartButtonState> {
  static ValueNotifier<Store?> changeSelectedStoreSubscription =
      ValueNotifier<Store?>(null);
  CartButtonBloc()
      : super(CartButtonState(
            selectedStore: null, selectedDeliveryAddress: null, distance: 0)) {
    print('stateInit: cartButton............................................');
    on<ChangeSelectedStore>(_mapChangeSelectedStoreToState);
    on<ChangeSelectedStoreButNotUse>(_mapChangeSelectedStoreButNotUse);
    on<ChangeSelectedDeliveryAddress>(_mapChangeSelectedAddressToState);
    on<ChangeSelectedOrderType>(_mapChangeSelectedOrderTypeToState);
    on<UpdateDataSelectedStore>(_mapUpdateDataSelectedStore);
  }

  void _mapChangeSelectedStoreToState(
      ChangeSelectedStore event, Emitter<CartButtonState> emit) {
    double distance =
        calculateDistanceStoreAndLatLng(event.selectedStore, initLatLng);

    emit(CartButtonState(
        selectedStore: event.selectedStore,
        selectedDeliveryAddress: state.selectedDeliveryAddress,
        selectedOrderType: OrderType.storePickup,
        distance: distance));
    changeSelectedStoreSubscription.value = event.selectedStore;
  }

  void _mapChangeSelectedStoreButNotUse(
      ChangeSelectedStoreButNotUse event, Emitter<CartButtonState> emit) {
    double distance = 0;
    if (state.selectedOrderType == OrderType.delivery) {
      distance = calculateDistanceStoreAndAddress(
          event.selectedStore, state.selectedDeliveryAddress);
    } else {
      distance =
          calculateDistanceStoreAndLatLng(event.selectedStore, initLatLng);
    }
    emit(CartButtonState(
        selectedStore: event.selectedStore,
        selectedDeliveryAddress: state.selectedDeliveryAddress,
        selectedOrderType: state.selectedOrderType,
        distance: distance));
    changeSelectedStoreSubscription.value = event.selectedStore;
  }

  void _mapChangeSelectedAddressToState(
      ChangeSelectedDeliveryAddress event, Emitter<CartButtonState> emit) {
    double distance = calculateDistanceStoreAndAddress(
        state.selectedStore, event.selectedDeliveryAddress);

    emit(CartButtonState(
        selectedStore: state.selectedStore,
        selectedDeliveryAddress: event.selectedDeliveryAddress,
        selectedOrderType: OrderType.delivery,
        distance: distance));
  }

  void _mapChangeSelectedOrderTypeToState(
      ChangeSelectedOrderType event, Emitter<CartButtonState> emit) {
    double distance = 0;
    if (event.selectedOrderType == OrderType.delivery) {
      distance = calculateDistanceStoreAndAddress(
          state.selectedStore, state.selectedDeliveryAddress);
    } else {
      distance =
          calculateDistanceStoreAndLatLng(state.selectedStore, initLatLng);
    }
    emit(CartButtonState(
        selectedStore: state.selectedStore,
        selectedDeliveryAddress: state.selectedDeliveryAddress,
        selectedOrderType: event.selectedOrderType,
        distance: distance));
  }

  void _mapUpdateDataSelectedStore(
      UpdateDataSelectedStore event, Emitter<CartButtonState> emit) {
    double distance = 0;
    if (state.selectedOrderType == OrderType.delivery) {
      distance = calculateDistanceStoreAndAddress(
          event.selectedStore, state.selectedDeliveryAddress);
    } else {
      distance =
          calculateDistanceStoreAndLatLng(event.selectedStore, initLatLng);
    }
    emit(CartButtonState(
        selectedStore: event.selectedStore,
        selectedDeliveryAddress: state.selectedDeliveryAddress,
        selectedOrderType: state.selectedOrderType,
        distance: distance));
    changeSelectedStoreSubscription.value = event.selectedStore;
  }

  double calculateDistanceFromLocation(MLocation addres1, MLocation address2) {
    return calculateDistance(
        addres1.lat, addres1.lng, address2.lat, address2.lng);
  }

  double calculateDistanceStoreAndLatLng(Store? store, LatLng? location) {
    if (store != null) {
      if (location != null) {
        return calculateDistance(store.address.lat, store.address.lng,
            initLatLng!.latitude, initLatLng!.longitude);
      }
    }
    return 0;
  }

  double calculateDistanceStoreAndAddress(
      Store? store, DeliveryAddress? deliveryAddress) {
    if (store != null) {
      if (deliveryAddress != null) {
        return calculateDistanceFromLocation(
            store.address, deliveryAddress.address);
      } else {
        return calculateDistanceStoreAndLatLng(store, initLatLng);
      }
    }
    return 0;
  }
}
