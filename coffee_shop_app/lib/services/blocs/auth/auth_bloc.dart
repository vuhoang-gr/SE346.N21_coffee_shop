import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_shop_app/screens/auth/auth_screen.dart';
import 'package:coffee_shop_app/screens/home/home_screen.dart';
import 'package:coffee_shop_app/services/apis/auth_api.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthAPI _authAPI = AuthAPI();

  AuthBloc()
      : super(AuthAPI.currentUser != null
            ? Authenticated(user: AuthAPI.currentUser!)
            : UnAuthenticated()) {
    on<EmailLogin>((event, emit) async {
      emit(Loading());
      var user = await _authAPI.emailLogin(event.email, event.password);
      print(user);
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(UnAuthenticated());
      }
    });

    on<GoogleLogin>((event, emit) async {
      emit(Loading());
      var user = await _authAPI.googleLogin();
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(UnAuthenticated());
      }
    });

    on<FacebookLogin>((event, emit) async {
      emit(Loading());
      var user = await _authAPI.facebookLogin();
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(UnAuthenticated());
      }
    });

    on<LogOut>(
      (event, emit) {
        unawaited(_authAPI.signOut());
        emit(UnAuthenticated());
      },
    );

    on<UserChanged>((event, emit) {
      if (event.user != null) {
        emit(Authenticated(user: event.user!));
      } else {
        emit(UnAuthenticated());
      }
    });
  }
}
