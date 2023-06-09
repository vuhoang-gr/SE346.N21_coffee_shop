// import 'package:cloud_firestore/cloud_firestore.dart' as cloudfire;
// import 'package:firebase_auth/firebase_auth.dart';
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
    // final firestore = cloudfire.FirebaseFirestore.instance;
    // FirebaseAuth.instance.userChanges().listen((user) async {
    //   if (user != null) {
    //     firestore
    //         .collection('orders')
    //         .where('store', isEqualTo: StoreAPI.currentStore!.id)
    //         .snapshots()
    //         .listen((data) async {
    //       for (int i = 0; i < data.docChanges.length; i++) {
    //         var change = data.docChanges[i];
    //         var order = await OrderAPI().rawGet(change.doc.id);
    //         if (order != null) {
    //           OrderAPI().allOrder[order.id] = order;
    //         }
    //       }
    //       if (data.docChanges.isNotEmpty) {
    //         add(UpdateOrderList(
    //             orderList: OrderAPI().allOrder.values.toList()));
    //         await Future.delayed(Duration(milliseconds: 5));
    //       }
    //     });
    //   }
    // });

    on<UpdateOrderList>(
      (event, emit) async {
        var orderList = event.orderList;
        var pickupList = orderList
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
        await Future.delayed(Duration(milliseconds: 5));
      },
    );

    on<FetchOrder>((event, emit) async {
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

    on<LoadOrder>(
      (event, emit) {
        emit(OrderLoaded(pickup: event.pickup, delivery: event.deli));
      },
    );
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
