import 'package:coffee_shop_staff/services/models/location.dart';

import 'address.dart';

class Store {
  String id;
  String sb;
  MLocation address;
  String phone;
  Map<String, bool> stateFood;
  Map<String, bool> stateTopping;
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
