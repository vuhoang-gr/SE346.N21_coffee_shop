import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_action_state.dart';

class AuthActionCubit extends Cubit<AuthActionState> {
  AuthActionCubit() : super(SignIn());
  void changeState(AuthActionState type) {
    emit(type);
  }
}
