import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_app/services/apis/address_api.dart';
import 'package:coffee_shop_app/services/apis/size_api.dart';
import 'package:coffee_shop_app/services/apis/store_api.dart';
import 'package:coffee_shop_app/services/apis/topping_api.dart';
import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:coffee_shop_app/services/models/order.dart' as Order;
import 'package:coffee_shop_app/services/models/order_food.dart';

import '../models/cart.dart';
import '../models/store.dart';
import 'auth_api.dart';

final fireStore = FirebaseFirestore.instance;
final orderRF = fireStore.collection('orders');
final storeRF = fireStore.collection('Store');

class OrderAPI {
  //singleton
  static final OrderAPI _orderAPI = OrderAPI._internal();
  factory OrderAPI() {
    return _orderAPI;
  }
  OrderAPI._internal();
  static List<Order.Order>? ordersPickup;
  static List<Order.Order>? ordersDelivery;

  loadOrder(List<Order.Order> list) async {
    ordersDelivery = [];
    ordersPickup = [];
    ordersDelivery!.addAll(list.where((ord) => ord.address != null));
    ordersPickup!.addAll(list.where((ord) => ord.pickupTime != null));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchData() {
    return orderRF
        .where('user', isEqualTo: AuthAPI.currentUser!.id)
        .snapshots();
  }

  Future<List<Order.Order>> fromQuerySnapshotToListOrder(
      QuerySnapshot<Map<String, dynamic>> data) async {
    List<Order.Order> list = [];
    for (var doc in data.docs) {
      if (doc.data().containsKey('pickupTime')) {
        list.add(await fromSnapshotOrder(doc));
      } else if (doc.data().containsKey('deliveryCost')) {
        list.add(await fromSnapshotOrder(doc));
      }
    }
    return list;
  }

  Future<Order.Order> fromSnapshotOrder(
      DocumentSnapshot<Map<String, dynamic>> json) async {
    var storeSnapshot = await storeRF.doc(json["store"]).get();
    String storeId = storeSnapshot.id;
    var store = storeSnapshot.data() as Map<String, dynamic>;
    return Order.Order(
        id: json.id,
        store: StoreAPI().fromFireStore(store, storeId),
        dateOrder: json['dateOrder'].toDate(),
        status: json['status'],
        discount: json['discountPrice'].toDouble(),
        total: json['totalPrice'].toDouble(),
        totalProduct: json['totalProduct'].toDouble(),
        deliveryCost: json.data()!.containsKey('deliveryCost')
            ? json['deliveryCost'].toDouble()
            : null,
        pickupTime: json.data()!.containsKey('pickupTime')
            ? json['pickupTime'].toDate()
            : null,
        address: json.data()!.containsKey('address')
            ? AddressAPI().fromFireStore(json['address'])
            : null,
        products: []);
  }

  Future<List<OrderFood>> loadOrderFood(Order.Order order) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> orderedFoodQuery =
          await orderRF.doc(order.id).collection('orderedFoods').get();
      final orderedFoods = orderedFoodQuery.docs
          .map((food) => OrderFood.fromSnapshot(food))
          .toList();
      return orderedFoods;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> addOrder(Order.Order order) async {
    return orderRF.add({
      'user': AuthAPI.currentUser!.id,
      'store': order.store!.id,
      'discountPrice': order.discount,
      'totalPrice': order.total,
      'dateOrder': order.dateOrder,
      'totalProduct': order.totalProduct,
      'status': order.status,
    }).then((value) {
      if (order.deliveryCost != null && order.address != null) {
        orderRF.doc(value.id).update({
          'deliveryCost': order.deliveryCost,
          'address': {
            'formattedAddress': order.address!.address.formattedAddress,
            'lat': order.address!.address.lat,
            'lng': order.address!.address.lng,
            'addressNote': order.address!.addressNote,
            'nameReceiver': order.address!.nameReceiver,
            'phone': order.address!.phone
          }
        });
      } else if (order.pickupTime != null) {
        orderRF.doc(value.id).update({'pickupTime': order.pickupTime});
      }

      for (var orderFood in order.products) {
        orderRF
            .doc(value.id)
            .collection('orderedFoods')
            .add({
              'name': orderFood.name,
              'image': orderFood.image,
              'quantity': orderFood.quantity,
              'size': orderFood.size,
              'topping': orderFood.topping,
              'unitPrice': orderFood.unitPrice,
              'note': orderFood.note,
              'totalPrice': orderFood.unitPrice * orderFood.quantity
            })
            .then((value) => print('Add order successfully'))
            .catchError((err) => print(err));
      }
    }).catchError((err) => print(err));
  }

  Order.Order fromCart(
      {required Cart cart,
      String status = 'Đang xử lí',
      required Store store,
      DeliveryAddress? address,
      DateTime? pickupTime}) {
    return Order.Order(
        dateOrder: DateTime.now(),
        status: status,
        store: store,
        discount: cart.discount,
        deliveryCost: cart.deliveryCost,
        total: cart.total,
        totalProduct: cart.totalFood,
        address: address,
        pickupTime: pickupTime,
        products: cart.products
            .map((e) => OrderFood(
                name: e.food.name,
                quantity: e.quantity,
                size: SizeApi()
                    .currentSizes
                    .firstWhere((s) => s.id == e.size)
                    .name,
                note: e.note,
                topping: e.topping == null
                    ? ''
                    : ToppingApi()
                        .currentToppings
                        .where((t) => e.topping!.contains(t.id))
                        .map((i) => i.name)
                        .join(' ,'),
                image: e.food.images[0],
                unitPrice: e.unitPrice))
            .toList());
  }
}
