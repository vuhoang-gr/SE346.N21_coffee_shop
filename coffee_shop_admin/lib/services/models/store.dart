import 'address.dart';

class Store {
  String id;
  String sb;
  Address address;
  String phone;
  Map<String, bool> stateFood;
  Store({
    required this.id,
    required this.sb,
    required this.address,
    required this.phone,
    required this.stateFood,
  });

  @override
  String toString() {
    return "$sb, $address";
  }
}
