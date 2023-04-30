import 'package:coffee_shop_app/services/models/delivery_address.dart';

abstract class EditAddressEvent {}

class SubAddressChanged extends EditAddressEvent {
  final String subAddress;

  SubAddressChanged({required this.subAddress});
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
  final DeliveryAddress? deliveryAddress;
  InitForm({required this.deliveryAddress});
}

