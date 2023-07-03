import 'package:coffee_shop_admin/services/models/location.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class EditAddressState extends Equatable {
  EditAddressState({
    this.address,
    this.addressNote = "",
    this.nameReceiver = "",
    this.phone = "",
  });

  MLocation? address;
  final String addressNote;
  final String nameReceiver;
  final String phone;

  EditAddressState copyWith({
    MLocation? address,
    String? addressNote,
    String? nameReceiver,
    String? phone,
  }) {
    return EditAddressState(
      address: address ?? this.address,
      addressNote: addressNote ?? this.addressNote,
      nameReceiver: nameReceiver ?? this.nameReceiver,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [address, addressNote, nameReceiver, phone];
}
