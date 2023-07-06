import 'package:coffee_shop_admin/services/models/location.dart';

class Store {
  String id;
  String sb;
  MLocation address;
  String phone;
  List<dynamic> images;
  String openTime;
  String closeTime;
  Store({
    required this.id,
    required this.sb,
    required this.address,
    required this.phone,
    this.images = const [],
    this.openTime = "08:00",
    this.closeTime = "22:00",
  });

  @override
  String toString() {
    return "$sb, $address";
  }
}
