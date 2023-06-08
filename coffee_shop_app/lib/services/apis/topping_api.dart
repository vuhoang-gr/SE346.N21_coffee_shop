import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/topping.dart';

class ToppingApi {
  //singleton
  static final ToppingApi _toppingAPI = ToppingApi._internal();
  factory ToppingApi() {
    return _toppingAPI;
  }
  ToppingApi._internal();

  List<Topping> currentToppings = [];

  final CollectionReference toppingReference =
      FirebaseFirestore.instance.collection('Topping');

  Stream<List<Topping>> fetchData() {
    return toppingReference.snapshots().map<List<Topping>>((snapshot) {
      List<Topping> toppings = [];
      for (var doc in snapshot.docs) {
        Topping? topping =
            fromFireStore(doc.data() as Map<String, dynamic>?, doc.id);
        if (topping != null) {
          toppings.add(topping);
        }
      }
      currentToppings = toppings;
      return toppings;
    });
  }

  Topping? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;
    return Topping(
        name: data['name'],
        image: data['image'],
        price: data['price'].toDouble(),
        id: id);
  }
}
