import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_event.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditAddressBloc extends Bloc<EditAddressEvent, EditAddressState> {
  EditAddressBloc() : super(EditAddressState()) {
    on<AddressChanged>(_onAddressChanged);
    on<NameReceiverChanged>(_onNameReceiverChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<AddressNoteChanged>(_onAddressNoteChanged);
    on<InitForm>(_onInitForm);
  }

  void _onAddressChanged(AddressChanged event, Emitter<EditAddressState> emit) {
    emit(
      state.copyWith(
        address: event.address,
      ),
    );
  }

  void _onNameReceiverChanged(
      NameReceiverChanged event, Emitter<EditAddressState> emit) {
    emit(
      state.copyWith(
        nameReceiver: event.nameReceiver,
      ),
    );
  }

  void _onPhoneChanged(PhoneChanged event, Emitter<EditAddressState> emit) {
    emit(
      state.copyWith(
        phone: event.phone,
      ),
    );
  }

  void _onAddressNoteChanged(
      AddressNoteChanged event, Emitter<EditAddressState> emit) {
    emit(
      state.copyWith(
        addressNote: event.addressNote,
      ),
    );
  }

  void _onInitForm(InitForm event, Emitter<EditAddressState> emit) {
    emit(
      state.copyWith(
        address: event.deliveryAddress?.address,
        addressNote: event.deliveryAddress?.addressNote ?? "",
        nameReceiver: event.deliveryAddress?.nameReceiver ?? "",
        phone: event.deliveryAddress?.phone ?? "",
      ),
    );
  }
}
