import 'package:equatable/equatable.dart';

import '../../models/location.dart';

class EditAddressState extends Equatable {
  EditAddressState({
    this.address,
    this.addressNote = "",
    this.nameReceiver = "",
    this.phone = "",
  });

  final MLocation? address;
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
      address: address,
      addressNote: addressNote ?? this.addressNote,
      nameReceiver: nameReceiver ?? this.nameReceiver,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [address, addressNote, nameReceiver, phone];
}