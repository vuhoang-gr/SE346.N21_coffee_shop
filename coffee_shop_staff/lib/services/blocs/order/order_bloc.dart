import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_shop_staff/services/apis/order_api.dart';
import 'package:coffee_shop_staff/services/apis/store_api.dart';
import 'package:coffee_shop_staff/services/models/order.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<LoadOrder>((event, emit) async {
      emit(OrderLoading());
      var orderListRaw = await OrderAPI().getAll(StoreAPI.currentStore!.id);
      var orderList = orderListRaw?.map((e) => e as Order).toList();
      var pickupList = orderList!
          .where(
            (element) => element.deliveryAddress == null,
          )
          .toList();
      var deliList = orderList
          .where(
            (element) => element.deliveryAddress != null,
          )
          .toList();
      emit(OrderLoaded(pickup: pickupList, delivery: deliList));
    });
    on<ChangeOrder>(
      (event, emit) async {
        await OrderAPI().update(event.order);

        var currentState = state;
        if (currentState is! OrderLoaded) {
          return;
        }
        var pickup = currentState.pickup;
        var deli = currentState.delivery;
        emit(OrderInitial());
        emit(OrderLoaded(pickup: pickup, delivery: deli));
      },
    );
  }
}
