import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_app/services/apis/auth_api.dart';
import 'package:coffee_shop_app/services/models/location.dart';
import 'package:coffee_shop_app/services/models/store.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreAPI {
  //singleton
  static final StoreAPI _storeAPI = StoreAPI._internal();
  factory StoreAPI() {
    return _storeAPI;
  }
  StoreAPI._internal();

  List<Store> currentStores = [];

  final firestore = FirebaseFirestore.instance;
  final CollectionReference storeReference =
      FirebaseFirestore.instance.collection('Store');
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  Stream<List<Store>> fetchData() {
    return storeReference.snapshots().asyncMap<List<Store>>((snapshot) async {
      List<dynamic> favoriteStores = [];
      if (FirebaseAuth.instance.currentUser != null) {
        DocumentSnapshot userData =
            await userReference.doc(AuthAPI.currentUser!.id).get();
        if (userData.exists) {
          favoriteStores =
              (userData.data() as Map<String, dynamic>)['favoriteStores'] ?? [];
        }
      }
      List<Store> stores = [];
      for (var doc in snapshot.docs) {
        Store? store =
            fromFireStore(doc.data() as Map<String, dynamic>, doc.id);
        if (store != null) {
          bool isFavorite = favoriteStores.any((element) => element == doc.id);
          store.isFavorite = isFavorite;
          stores.add(store);
        }
      }

      currentStores = stores;

      return stores;
    });
  }

  Future<bool> updateFavorite(String storeId) async {
    try {
      final userDoc = await userReference.doc(AuthAPI.currentUser!.id).get();
      final favorites =
          (userDoc.data() as Map<String, dynamic>)['favoriteStores'] ?? [];
      if (favorites.contains(storeId)) {
        favorites.remove(storeId);
      } else {
        favorites.add(storeId);
      }
      await userReference
          .doc(AuthAPI.currentUser!.id)
          .update({'favoriteStores': favorites});
      return true;
    } catch (e) {
      return false;
    }
  }

  Store? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;

    Map<String, List<String>> sizeIds = {};
    Map<String, dynamic> sizeFireStores = data["stateFood"] ?? {};

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
        stateTopping: data['stateTopping']?.cast<String>() ?? []);
  }
}
