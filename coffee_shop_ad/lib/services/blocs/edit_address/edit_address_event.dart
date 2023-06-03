import 'package:coffee_shop_admin/services/models/address.dart';

import '../../models/location.dart';

abstract class EditAddressEvent {}

class AddressChanged extends EditAddressEvent {
  final MLocation address;

  AddressChanged({required this.address});
}

class AddressNoteChanged extends EditAddressEvent {
  final String addressNote;
  AddressNoteChanged({required this.addressNote});
}

class NameReceiverChanged extends EditAddressEvent {
  final String nameReceiver;
  NameReceiverChanged({required this.nameReceiver});
}

class PhoneChanged extends EditAddressEvent {
  final String phone;
  PhoneChanged({required this.phone});
}

class InitForm extends EditAddressEvent {
  final Address? deliveryAddress;
  InitForm({required this.deliveryAddress});
}
