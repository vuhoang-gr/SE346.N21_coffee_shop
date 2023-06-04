import '../models/topping.dart';

class ToppingApi {
  //singleton
  static final ToppingApi _toppingAPI = ToppingApi._internal();
  factory ToppingApi() {
    return _toppingAPI;
  }
  ToppingApi._internal();

  Topping? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;
    return Topping(
        name: data['name'], image: data['image'], price: data['price'].toDouble(), id: id);
  }

  Future<List<Topping>> changeRefToObject(
      List<dynamic> toppings, List<String>? bannedTopping) async {
    List<Topping> results = [];
    for (var toppingRef in toppings) {
      var doc = await toppingRef.get();
      if (doc != null) {
        if (bannedTopping != null && bannedTopping.contains(doc.id)) {
          continue;
        }
        Topping? topping = fromFireStore(doc.data() as Map<String, dynamic>, doc.id);
        if (topping != null) {
          results.add(topping);
        }
      }
    }
    return results;
  }
}
