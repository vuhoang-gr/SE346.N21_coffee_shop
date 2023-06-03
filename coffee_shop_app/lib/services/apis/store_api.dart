import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_app/services/apis/auth_api.dart';
import 'package:coffee_shop_app/services/models/location.dart';
import 'package:coffee_shop_app/services/models/store.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../functions/calculate_distance.dart';

class StoreAPI {
  //singleton
  static final StoreAPI _storeAPI = StoreAPI._internal();
  factory StoreAPI() {
    return _storeAPI;
  }
  StoreAPI._internal();

  final firestore = FirebaseFirestore.instance;
  final CollectionReference storeReference =
      FirebaseFirestore.instance.collection('Store');
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  static List<Store>? currentStores;

  Future<List<Store>> fetchData(LatLng? location) async {
    QuerySnapshot storeSnapshot = await storeReference.get();

    List<dynamic> favoriteStores = [];
    if (AuthAPI.currentUser != null) {
      DocumentSnapshot userData =
          await userReference.doc(AuthAPI.currentUser!.id).get();
      if (userData.exists) {
        favoriteStores =
            (userData.data() as Map<String, dynamic>)['favoriteStores'] ?? [];
      }
    }

    List<Store> stores = [];
    for (QueryDocumentSnapshot doc in storeSnapshot.docs) {
      Store? store = fromFireStore(doc.data() as Map<String, dynamic>, doc.id);
      if (store != null) {
        bool isFavorite = favoriteStores.any((element) => element == doc.id);
        store.isFavorite = isFavorite;
        stores.add(store);
      }
    }

    if (location != null) {
      stores.sort((a, b) {
        double distanceA = 0, distanceB = 0;

        distanceA = calculateDistance(a.address.lat, a.address.lng,
            location.latitude, location.longitude);
        distanceB = calculateDistance(b.address.lat, b.address.lng,
            location.latitude, location.longitude);

        return distanceA.compareTo(distanceB);
      });
    }

    return stores;
  }

  Store? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;

    Map<String, List<String>> sizeIds = {};
    Map<String, dynamic> sizeFireStores = data["stateFood"];

    sizeFireStores.forEach((key, value) {
      if (value is bool) {
        sizeIds[key] = [];
      } else {
        sizeIds[key] = value.cast<String>();
      }
    });

    return Store(
        id: id,
        sb: data['shortName'],
        address: MLocation(
            formattedAddress: data['address']['formattedAddress'],
            lat: data['address']['lat'],
            lng: data['address']['lng']),
        phone: data['phone'],
        images: data['images'].cast<String>(),
        timeOpen: data['timeOpen'].toDate(),
        timeClose: data['timeClose'].toDate(),
        stateFood: sizeIds,
        stateTopping: data['stateTopping'].cast<String>());
  }
}
