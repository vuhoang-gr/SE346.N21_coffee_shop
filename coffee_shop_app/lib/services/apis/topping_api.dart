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
}
