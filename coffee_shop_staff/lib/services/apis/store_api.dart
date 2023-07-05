import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_staff/services/models/food.dart';
import 'package:coffee_shop_staff/services/models/location.dart';
import 'package:flutter/material.dart';

import '../models/store.dart';

class StoreAPI {
  //singleton
  static final StoreAPI _storeAPI = StoreAPI._internal();
  factory StoreAPI() {
    return _storeAPI;
  }
  StoreAPI._internal();

  final firestore = FirebaseFirestore.instance;

  static Store? get currentStore => storeSubscription.value;
  static set currentStore(Store? value) {
    storeSubscription.value = value;
  }

  static ValueNotifier<Store?> storeSubscription = ValueNotifier<Store?>(null);

  Map<String, dynamic> _rawStore = {};

  Store? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;
    return Store(
      id: id,
      sb: data['shortName'],
      address: MLocation(
        formattedAddress: data['address']['formattedAddress'],
        lat: data['address']['lat'],
        lng: data['address']['lng'],
      ),
      phone: data['phone'],
      images: data['images'].cast<String>(),
      timeOpen: data['timeOpen'].toDate(),
      timeClose: data['timeClose'].toDate(),
      stateFood: [],
      stateTopping: [],
      stateFoodRaw: data['stateFood'],
      stateToppingRaw: (data['stateTopping'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toFireStore(Store store) {
    final data = _rawStore;
    data['stateTopping'] = store.stateToppingRaw;
    data['stateFood'] = store.stateFoodRaw;
    return data;
  }

  Future<Store?> get(String id) async {
    // print(id);
    try {
      var raw = await firestore.collection('Store').doc(id).get();
      var data = raw.data();
      _rawStore = data ?? {};
      currentStore = fromFireStore(data, id);
      return currentStore;
    } catch (e) {
      return null;
    }
  }

  update(Store store) async {
    //convert stateTopping
    List<String> stateTopping = [];
    for (int i = 0; i < store.stateTopping.length; i++) {
      if (store.stateTopping[i].isStocking == false) {
        stateTopping.add(store.stateTopping[i].item.id);
      }
    }
    store.stateToppingRaw = stateTopping;

    //convert stateFood
    Map<String, dynamic> stateFood = {};
    for (int i = 0; i < store.stateFood.length; i++) {
      if (!store.stateFood[i].isStocking) {
        store.stateFood[i].blockSize =
            (store.stateFood[i].item as Food).sizes!.map((e) => e.id).toList();
        stateFood[store.stateFood[i].id] = false;
      } else if (store.stateFood[i].blockSize != null &&
          store.stateFood[i].blockSize!.isNotEmpty) {
        if (store.stateFood[i].blockSize!.length ==
            (store.stateFood[i].item as Food).sizes!.length) {
          store.stateFood[i].blockSize = [];
          continue;
        }
        stateFood[store.stateFood[i].id] = store.stateFood[i].blockSize;
      }
    }
    store.stateFoodRaw = stateFood;

    await firestore
        .collection('Store')
        .doc(store.id)
        .update(toFireStore(store));
    currentStore = store;
  }
}
