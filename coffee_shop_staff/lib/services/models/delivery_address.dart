import 'address.dart';

class DeliveryAddress {
  final Address address;
  final String nameReceiver;
  final String phone;
  DeliveryAddress({
    required this.address,
    required this.nameReceiver,
    required this.phone,
  });
}
