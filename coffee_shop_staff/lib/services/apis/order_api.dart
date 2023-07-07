import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_staff/services/apis/auth_api.dart';
import 'package:coffee_shop_staff/services/apis/store_api.dart';
import 'package:coffee_shop_staff/services/models/ordered_food.dart';
import 'package:coffee_shop_staff/utils/constants/order_enum.dart';
import '../models/delivery_address.dart';
import '../models/location.dart';
import '../models/order.dart' as od;

class OrderAPI {
  //singleton
  static final OrderAPI _oderedAPI = OrderAPI._internal();
  factory OrderAPI() {
    return _oderedAPI;
  }
  OrderAPI._internal();

  final firestore = FirebaseFirestore.instance;

  Map<String, od.Order> allOrder = {};

  Future<od.Order?> fromFireStore(Map<String, dynamic>? data, String id) async {
    if (data == null) return null;
    // var x = firestore.collection('')
    var user = await AuthAPI().get(data['user']);
    if (user == null) return null;
    var productList = await getOrderedFood(id);
    return od.Order(
      id: id,
      user: user,
      store: StoreAPI.currentStore!,
      orderDate: DateTime.tryParse(
              (data['dateOrder'] ?? Timestamp.now()).toDate().toString()) ??
          DateTime.now(),
      productList: productList ?? [],
      status: (data['status'] as String).toOrderStatus(),
      totalPrice: data['totalPrice'],
      discount: data['discountPrice'],
      deliveryFee: data['deliveryCost'],
      pickupTime: data['pickupTime'] != null
          ? (data['pickupTime'] as Timestamp).toDate()
          : null,
      deliveryAddress: data['address'] != null
          ? DeliveryAddress(
              address: MLocation(
                  formattedAddress: data['address']['formattedAddress'],
                  lat: data['address']['lat'].toDouble(),
                  lng: data['address']['lng'].toDouble()),
              addressNote: data['address']['addressNote'],
              nameReceiver: data['address']['nameReceiver'],
              phone: data['address']['phone'],
            )
          : null,
    );
  }

  Map<String, dynamic> toFireStore(od.Order order) {
    final data = <String, dynamic>{};
    return data;
  }

  Future<od.Order?> get(String id) async {
    if (allOrder.containsKey(id)) {
      return allOrder[id];
    }
    var raw = await firestore.collection('orders').doc(id).get();
    var data = raw.data();
    var res = await fromFireStore(data, id);
    if (res != null) {
      allOrder[id] = res;
    }
    return res;
  }

  Future<od.Order?> rawGet(String id) async {
    var raw = await firestore.collection('orders').doc(id).get();
    var data = raw.data();
    var res = await fromFireStore(data, id);
    if (res != null) {
      allOrder[id] = res;
    }
    return res;
  }

  Future<List<od.Order>?> getList(List<String> listId) async {
    List<od.Order>? res = [];
    for (var item in listId) {
      var temp = await get(item);
      if (temp != null) {
        res.add(temp);
      }
    }
    if (res.isEmpty) {
      return null;
    }
    return res;
  }

  Future<List<od.Order?>?> getAll(String storeId) async {
    var raw = await firestore
        .collection('orders')
        .where('store', isEqualTo: storeId)
        .get();
    var data = raw.docs
        .map((e) => <String, dynamic>{'id': e.id, 'data': e.data()})
        .toList();
    List<od.Order?>? res = [];
    for (var item in data) {
      var temp = await fromFireStore(item['data'], item['id']);
      if (temp != null) {
        allOrder[item['id']] = temp;
      }
      res.add(temp);
    }

    return res;
  }

  Future<List<OrderedFood>?> getOrderedFood(String orderId) async {
    var foodDocs = await firestore
        .collection('orders')
        .doc(orderId)
        .collection('orderedFoods')
        .get();

    var foodListRaw = foodDocs.docs
        .map((e) => <String, dynamic>{'id': e.id, 'data': e.data()})
        .toList();
    var res = foodListRaw.map((e) {
      var data = e['data'];
      return OrderedFood(
        id: e['id'],
        name: data['name'],
        amount: data['quantity'],
        size: data['size'],
        image: data['image'],
        unitPrice: data['unitPrice'],
        totalPrice: data['totalPrice'],
        topping: data['topping'],
      );
    }).toList();
    return res;
  }

  Future<bool> update(od.Order order) async {
    allOrder[order.id] = order;
    await firestore
        .collection('orders')
        .doc(order.id)
        .update({'status': order.status.name});
    return true;
  }
}
