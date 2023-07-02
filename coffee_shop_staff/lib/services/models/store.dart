import 'package:coffee_shop_staff/services/models/location.dart';
import 'package:coffee_shop_staff/services/models/store_product.dart';
import 'food_checker.dart';

class Store {
  String id;
  String sb;
  MLocation address;
  String phone;
  List<FoodChecker> stateFood;
  Map<String, dynamic> stateFoodRaw;
  List<String> stateToppingRaw;
  List<StoreProduct> stateTopping;
  late DateTime timeOpen;
  late DateTime timeClose;
  List<String> images;
  Store(
      {required this.id,
      required this.sb,
      required this.address,
      required this.phone,
      required this.stateFood,
      required this.stateTopping,
      required this.images,
      required this.stateFoodRaw,
      required this.stateToppingRaw,
      timeOpen,
      timeClose}) {
    this.timeOpen = timeOpen ?? DateTime.now();
    this.timeClose = timeClose ?? DateTime.now();
  }

  @override
  String toString() {
    return "$sb, $address";
  }
}
