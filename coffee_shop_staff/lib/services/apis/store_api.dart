import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_staff/services/models/location.dart';
import 'package:coffee_shop_staff/services/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

import '../models/store.dart';

class StoreAPI {
  //singleton
  static final StoreAPI _authAPI = StoreAPI._internal();
  factory StoreAPI() {
    return _authAPI;
  }
  StoreAPI._internal();

  final firestore = FirebaseFirestore.instance;

  static Store? get currentStore => storeSubscription.value;
  static set currentStore(Store? value) {
    storeSubscription = ValueNotifier(value);
  }

  static ValueNotifier<Store?> storeSubscription = ValueNotifier<Store?>(null);

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
      stateFood: {},
      stateTopping: {},
    );
  }

  Map<String, dynamic> toFireStore(Store store) {
    final data = <String, dynamic>{};
    return data;
  }

  Future<Store?> get(String id) async {
    var raw = await firestore.collection('Store').doc(id).get();
    var data = raw.data();
    return fromFireStore(data, id);
  }

  update(Store store) async {
    await firestore
        .collection('users')
        .doc(store.id)
        .update(toFireStore(store));
    currentStore = store;
  }
}
