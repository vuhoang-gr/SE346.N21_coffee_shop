import 'package:coffee_shop_staff/services/apis/auth_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import '../auth_action/auth_action_cubit.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthAPI _authAPI = AuthAPI();

  AuthBloc() : super(Loading()) {
    on<EmailLogin>((event, emit) async {
      emit(Loading());
      var user = await _authAPI.emailLogin(event.email, event.password);
      // print(user);
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(UnAuthenticated(
            message: 'Email or password is wrong', pageState: Login()));
      }
    });

    on<LogOut>(
      (event, emit) {
        emit(UnAuthenticated(message: 'Logged out', pageState: Login()));
        _authAPI.signOut();
      },
    );

    on<UserChanged>((event, emit) async {
      if (event.user != null) {
        await _authAPI.update(event.user!);
        emit(Authenticated(user: event.user!));
      } else {
        emit(UnAuthenticated());
      }
    });

    on<SetLoading>((event, emit) {
      emit(Loading());
    });
  }
}
