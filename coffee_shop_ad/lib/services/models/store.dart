import 'package:coffee_shop_admin/services/models/location.dart';

class Store {
  String id;
  String sb;
  MLocation address;
  String phone;
  List<dynamic> images;
  // DateTime openTime;
  // DateTime closeTime;
  Store({
    required this.id,
    required this.sb,
    required this.address,
    required this.phone,
    this.images = const [],
    // this.openTime = const DateTime.parse('2023-06-14 08:00'),
    // this.closeTime = const DateTime.parse('2023-06-14 22:00'),
  });

  @override
  String toString() {
    return "$sb, $address";
  }
}
