import 'package:coffee_shop_admin/services/models/location.dart';

class Store {
  String id;
  String sb;
  MLocation address;
  String phone;
  List<dynamic> images;
  Store({
    required this.id,
    required this.sb,
    required this.address,
    required this.phone,
    this.images = const [],
  });

  @override
  String toString() {
    return "$sb, $address";
  }
}
