import 'dart:async';

import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_state.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_event.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../store_store/store_store_state.dart';

class CartButtonBloc extends Bloc<CartButtonEvent, CartButtonState> {
  final StoreStoreBloc _storeStoreBloc;
  final ProductStoreBloc _foodStoreBloc;
  late StreamSubscription _storeStoreSubscription;

  CartButtonBloc(this._storeStoreBloc, this._foodStoreBloc)
      : super(CartButtonState(
            selectedStore: null, selectedDeliveryAddress: null)) {
    on<ChangeSelectedStore>(_mapChangeSelectedStoreToState);
    on<ChangeSelectedStoreButNotUse>(_mapChangeSelectedStoreButNotUse);
    on<ChangeSelectedDeliveryAddress>(_mapChangeSelectedAddressToState);
    on<ChangeSelectedOrderType>(_mapChangeSelectedOrderTypeToState);
    on<UpdateDataSelectedStore>(_mapUpdateDataSelectedStore);

    _storeStoreSubscription = _storeStoreBloc.stream.listen((state) {
      if (state is FetchedState) {
        add(UpdateDataSelectedStore(selectedStore: state.selectedStore));
      }
    });
  }

  void _mapChangeSelectedStoreToState(
      ChangeSelectedStore event, Emitter<CartButtonState> emit) {
    emit(CartButtonState(
        selectedStore: event.selectedStore,
        selectedDeliveryAddress: state.selectedDeliveryAddress,
        selectedOrderType: OrderType.storePickup));
    _foodStoreBloc.add(FetchData(stateFood: event.selectedStore.stateFood));
  }

  void _mapChangeSelectedStoreButNotUse(
      ChangeSelectedStoreButNotUse event, Emitter<CartButtonState> emit) {
    emit(CartButtonState(
        selectedStore: event.selectedStore,
        selectedDeliveryAddress: state.selectedDeliveryAddress,
        selectedOrderType: state.selectedOrderType));
    _foodStoreBloc.add(FetchData(stateFood: event.selectedStore.stateFood));
  }

  void _mapChangeSelectedAddressToState(
      ChangeSelectedDeliveryAddress event, Emitter<CartButtonState> emit) {
    emit(CartButtonState(
        selectedStore: state.selectedStore,
        selectedDeliveryAddress: event.selectedDeliveryAddress,
        selectedOrderType: OrderType.delivery));
  }

  void _mapChangeSelectedOrderTypeToState(
      ChangeSelectedOrderType event, Emitter<CartButtonState> emit) {
    emit(CartButtonState(
        selectedStore: state.selectedStore,
        selectedDeliveryAddress: state.selectedDeliveryAddress,
        selectedOrderType: event.selectedOrderType));
  }

  void _mapUpdateDataSelectedStore(
      UpdateDataSelectedStore event, Emitter<CartButtonState> emit) {
    emit(CartButtonState(
        selectedStore: event.selectedStore,
        selectedDeliveryAddress: state.selectedDeliveryAddress,
        selectedOrderType: state.selectedOrderType));
    _foodStoreBloc.add(FetchData(stateFood: event.selectedStore?.stateFood));
  }

  @override
  Future<void> close() {
    _storeStoreSubscription.cancel();
    return super.close();
  }
}
