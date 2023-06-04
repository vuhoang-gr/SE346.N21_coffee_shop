import 'package:coffee_shop_app/services/models/location.dart';

class Store {
  String id;
  String sb;
  MLocation address;
  String phone;
  List<String> images;
  Map<String, List<String>> stateFood;
  List<String> stateTopping;
  DateTime timeOpen;
  DateTime timeClose;
  bool isFavorite;
  Store({
    required this.id,
    required this.sb,
    required this.address,
    required this.phone,
    required this.images,
    required this.stateFood,
    required this.stateTopping,
    required this.timeOpen,
    required this.timeClose,
    this.isFavorite = false,
  });

  @override
  String toString() {
    return "$sb, $address";
  }
}
