import 'package:coffee_shop_admin/services/models/location.dart';

class Address {
  final MLocation address;
  final String addressNote;
  final String nameReceiver;
  final String phone;
  Address({
    required this.address,
    required this.addressNote,
    required this.nameReceiver,
    required this.phone,
  });
}
