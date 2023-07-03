import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/store.dart';
import '../models/topping.dart';

class ToppingAPI {
  //singleton
  static final ToppingAPI _toppingAPI = ToppingAPI._internal();
  factory ToppingAPI() {
    return _toppingAPI;
  }
  ToppingAPI._internal();

  final firestore = FirebaseFirestore.instance;

  Map<String, Topping> allTopping = {};

  Topping? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;
    return Topping(
      id: id,
      name: data['name'],
      price: (data['price'] as int).toDouble(),
      image: data['image'],
    );
  }

  Map<String, dynamic> toFireStore(Store store) {
    final data = <String, dynamic>{};
    return data;
  }

  Future<Topping?> get(String id) async {
    if (allTopping.containsKey(id)) {
      return allTopping[id];
    }
    var raw = await firestore.collection('Topping').doc(id).get();
    var data = raw.data();
    var res = fromFireStore(data, id);
    if (res != null) {
      allTopping[id] = res;
    }
    return res;
  }

  Future<List<Topping>?> getList(List<String> listId) async {
    List<Topping>? res = [];
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

  Future<List<Topping?>?> getAll() async {
    var raw = await firestore.collection('Topping').get();
    final allData = raw.docs.map((doc) {
      var x = doc.data();
      x['id'] = doc.id;
      return x;
    }).toList();
    List<Topping?>? res = [];
    for (var item in allData) {
      res.add(fromFireStore(item, item['id']));
    }
    return res;
  }
}
