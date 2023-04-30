import 'package:equatable/equatable.dart';

class EditAddressState extends Equatable {
  const EditAddressState({
    this.subAddress = "",
    this.nameReceiver = "",
    this.phone = "",
  });

  final String subAddress;
  final String nameReceiver;
  final String phone;

  EditAddressState copyWith({
    String? subAddress,
    String? nameReceiver,
    String? phone,
  }) {
    return EditAddressState(
      subAddress: subAddress ?? this.subAddress,
      nameReceiver: nameReceiver ?? this.nameReceiver,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object> get props => [subAddress, nameReceiver, phone];
}