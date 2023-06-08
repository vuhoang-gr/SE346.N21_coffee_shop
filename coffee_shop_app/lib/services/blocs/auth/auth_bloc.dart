import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_shop_app/services/apis/auth_api.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

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

    on<GoogleLogin>((event, emit) async {
      emit(Loading());
      var user = await _authAPI.googleLogin();
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(UnAuthenticated(message: 'Login Failed', pageState: Login()));
      }
    });

    on<FacebookLogin>((event, emit) async {
      emit(Loading());
      var user = await _authAPI.facebookLogin();
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(UnAuthenticated(message: 'Login Failed', pageState: Login()));
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
  }
}
