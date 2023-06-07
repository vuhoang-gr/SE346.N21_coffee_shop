import 'package:coffee_shop_app/services/apis/order_api.dart';
import 'package:coffee_shop_app/services/blocs/order/order_list_state.dart';
import 'package:coffee_shop_app/services/models/order.dart';
import 'package:coffee_shop_app/utils/constants/string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDeliveryCubit extends Cubit<OrderListState> {
  OrderDeliveryCubit()
      : super(OrderNormalState(
          listDeliveryOrders: [],
          listPickupOrders: [],
          isLoaded: false,
        ));

  loadOrder() async {
    await OrderAPI().loadOrder();
    if (state is OrderHistoryState) {
      showHistory();
    } else if (state is OrderNormalState) {
      showOrder();
    }
  }

  needLoad() {
    if (state is OrderHistoryState) {
      emit(OrderHistoryState(
          listDeliveryOrders: state.listDeliveryOrders,
          listPickupOrders: state.listPickupOrders,
          isLoaded: false));
    } else if (state is OrderNormalState) {
      emit(OrderNormalState(
          listDeliveryOrders: state.listDeliveryOrders,
          listPickupOrders: state.listPickupOrders,
          isLoaded: false));
    }
  }

  needHistory(bool isHistory) {
    if (isHistory) {
      showHistory();
    } else {
      showOrder();
    }
  }

  showHistory() {
    final List<Order> listDeli = [];
    final List<Order> listPickup = [];
    for (var ord in OrderAPI.ordersDelivery!) {
      if (ord.status == orderCancelled ||
          ord.status == orderDelivered ||
          ord.status == orderCompleted) {
        listDeli.add(ord);
      }
    }
    for (var p in OrderAPI.ordersPickup!) {
      if (p.status == orderCancelled ||
          p.status == orderDelivered ||
          p.status == orderCompleted) {
        listPickup.add(p);
      }
    }
    emit(OrderHistoryState(
        listDeliveryOrders: listDeli,
        listPickupOrders: listPickup,
        isLoaded: true));
  }

  showOrder() {
    final List<Order> listDeli = [];
    final List<Order> listPickup = [];

    for (var ord in OrderAPI.ordersDelivery!) {
      if (ord.status != orderCancelled &&
          ord.status != orderDelivered &&
          ord.status != orderCompleted) {
        listDeli.add(ord);
      }
    }
    for (var p in OrderAPI.ordersPickup!) {
      if (p.status != orderCancelled &&
          p.status != orderDelivered &&
          p.status != orderCompleted) {
        listPickup.add(p);
      }
    }
    emit(OrderNormalState(
        listDeliveryOrders: listDeli,
        listPickupOrders: listPickup,
        isLoaded: true));
  }
}
