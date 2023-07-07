import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_staff/services/apis/size_api.dart';
import 'package:coffee_shop_staff/services/apis/store_api.dart';
import 'package:coffee_shop_staff/services/apis/topping_api.dart';
import 'package:coffee_shop_staff/services/models/food.dart';
import 'package:coffee_shop_staff/services/models/food_checker.dart';
import '../models/size.dart';
import '../models/store.dart';
import '../models/topping.dart';

class FoodAPI {
  //singleton
  static final FoodAPI _foodAPI = FoodAPI._internal();
  factory FoodAPI() {
    return _foodAPI;
  }
  FoodAPI._internal();

  Map<String, Food> allFood = {};

  final firestore = FirebaseFirestore.instance;

  Stream<List<Food>> fetchData(Map<String, List<String>>? stateFood) {
    return firestore
        .collection('Food')
        .snapshots()
        .asyncMap<List<Food>>((snapshot) async {
      if (stateFood == null) {
        return [];
      }

      List<Food> foods = [];
      for (var doc in snapshot.docs) {
        Food? food = await fromFireStore(doc.data(), doc.id);
        if (food != null) {
          foods.add(food);
          allFood[doc.id] = food;
        }
      }

      foods.sort((a, b) => a.name.compareTo(b.name));

      return foods;
    });
  }

  Future<Food?> fromFireStore(Map<String, dynamic>? data, String id) async {
    try {
      if (data == null) return null;
      List<Size>? sizes = await SizeAPI().getList(
          (data['sizes'] as List<dynamic>).map((e) => e as String).toList());
      List<Topping>? toppings = await ToppingAPI().getList(
          (data['toppings'] as List<dynamic>).map((e) => e as String).toList());
      sizes ??= [];
      toppings ??= [];
      return Food(
          id: id,
          name: data['name'],
          price: (data['price'] as int).toDouble(),
          description: data['description'],
          images: (data['images'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
          sizes: sizes,
          toppings: toppings);
    } catch (e) {
      print('Food fromFireStore error: $e');
      return null;
    }
  }

  Map<String, dynamic> toFireStore(Store store) {
    final data = <String, dynamic>{};
    return data;
  }

  Future<Food?> get(String id) async {
    if (allFood.containsKey(id)) {
      return allFood[id];
    }
    var raw = await firestore.collection('Food').doc(id).get();
    var data = raw.data();
    var res = await fromFireStore(data, id);
    if (res != null) {
      allFood[id] = res;
    }
    return res;
  }

  Future<List<Food>?> getList(List<String> listId) async {
    List<Food>? res = List.empty();
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

  Future<List<Food?>?> getAll() async {
    var raw = await firestore.collection('Food').get();
    final allData = raw.docs.map((doc) {
      var x = doc.data();
      x['id'] = doc.id;
      return x;
    }).toList();
    List<Food?>? res = [];
    for (var item in allData) {
      var temp = await fromFireStore(item, item['id']);
      res.add(temp);
      if (temp != null) {
        allFood[item['id']] = temp;
      }
    }
    return res;
  }

  List<FoodChecker> toChecker(List<Food?>? list) {
    List<FoodChecker> res = [];
    if (list == null) return [];
    for (var item in list) {
      res.add(FoodChecker(
          id: item!.id,
          item: item,
          store: StoreAPI.currentStore,
          blockSize: []));
    }
    return res;
  }
}
