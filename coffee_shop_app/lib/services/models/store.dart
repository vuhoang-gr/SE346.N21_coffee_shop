import 'address.dart';

class Store {
  String id;
  String sb;
  Address address;
  String phone;
  Store({
    required this.id,
    required this.sb,
    required this.address,
    required this.phone,
  });

  @override
  String toString() {
    return "$sb, $address";
  }
}
