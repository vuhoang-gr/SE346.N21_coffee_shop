import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_event.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditAddressBloc extends Bloc<EditAddressEvent, EditAddressState> {
  EditAddressBloc() : super(const EditAddressState()) {
    on<SubAddressChanged>(_onSubAddressChanged);
    on<NameReceiverChanged>(_onNameReceiverChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<InitForm>(_onInitForm);
  }

  void _onSubAddressChanged(
      SubAddressChanged event, Emitter<EditAddressState> emit) {
    emit(
      state.copyWith(
        subAddress: event.subAddress,
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

  void _onInitForm(InitForm event, Emitter<EditAddressState> emit) {
    emit(
      state.copyWith(
        subAddress: event.deliveryAddress?.address.shortName ?? "",
        nameReceiver: event.deliveryAddress?.nameReceiver ?? "",
        phone: event.deliveryAddress?.phone ?? "",
      ),
    );
  }
}
