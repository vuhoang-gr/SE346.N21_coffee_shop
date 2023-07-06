import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_app/services/apis/order_api.dart';
import 'package:coffee_shop_app/services/blocs/order/order_list_state.dart';
import 'package:coffee_shop_app/services/models/order.dart' as Order;
import 'package:coffee_shop_app/utils/constants/string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDeliveryCubit extends Cubit<OrderListState> {
  OrderDeliveryCubit()
      : super(OrderNormalState(
          listDeliveryOrders: [],
          listPickupOrders: [],
          isLoaded: false,
        )) {
    loadFromFirebase();
    _userChangedSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        loadFromFirebase();
      }
    });
  }
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _oderSubscription;
  late StreamSubscription _userChangedSubscription;
  loadFromFirebase() {
    _oderSubscription = OrderAPI().fetchData().listen((snapshot) async {
      needLoad();
      List<Order.Order> orderList = [];
      var list = await OrderAPI().fromQuerySnapshotToListOrder(snapshot);
      for (var order in list) {
        var listFood = await OrderAPI().loadOrderFood(order);
        orderList.add(order.copyWith(products: listFood));
      }
      OrderAPI().loadOrder(orderList);
      loadOrder();
      finishLoad();
    });
  }

  loadOrder() async {
    // await OrderAPI().loadOrder();
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

  finishLoad() {
    if (state is OrderHistoryState) {
      emit(OrderHistoryState(
          listDeliveryOrders: state.listDeliveryOrders,
          listPickupOrders: state.listPickupOrders,
          isLoaded: true));
    } else if (state is OrderNormalState) {
      emit(OrderNormalState(
          listDeliveryOrders: state.listDeliveryOrders,
          listPickupOrders: state.listPickupOrders,
          isLoaded: true));
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
    final List<Order.Order> listDeli = [];
    final List<Order.Order> listPickup = [];
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
    final List<Order.Order> listDeli = [];
    final List<Order.Order> listPickup = [];

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

  @override
  Future<void> close() {
    // TODO: implement close
    _oderSubscription.cancel();
    _userChangedSubscription.cancel();
    return super.close();
  }
}
