import 'package:coffee_shop_app/services/models/location.dart';

class Store {
  String id;
  String sb;
  MLocation address;
  String phone;
  bool isFavorite;
  Store({
    required this.id,
    required this.sb,
    required this.address,
    required this.phone,
    this.isFavorite = false,
  });

  @override
  String toString() {
    return "$sb, $address";
  }
}
