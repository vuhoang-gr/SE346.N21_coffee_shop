import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartButtonBloc extends Bloc<CartButtonEvent, CartButtonState> {
  CartButtonBloc()
      : super(CartButtonState(
            selectedStore: null, selectedDeliveryAddress: null)) {
    on<ChangeSelectedStore>(_mapChangeSelectedStoreToState);
    on<ChangeSelectedDeliveryAddress>(_mapChangeSelectedAddressToState);
    on<ChangeSelectedOrderType>(_mapChangeSelectedOrderTypeToState);
  }

  void _mapChangeSelectedStoreToState(
      ChangeSelectedStore event, Emitter<CartButtonState> emit) {
    emit(CartButtonState(
        selectedStore: event.selectedStore,
        selectedDeliveryAddress: state.selectedDeliveryAddress,
        selectedOrderType: OrderType.storePickup));
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
}