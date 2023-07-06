import 'package:coffee_shop_admin/services/apis/auth_api.dart';
import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/blocs/auth_action/auth_action_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_shop_admin/services/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthAPI _authAPI = AuthAPI();

  AuthBloc() : super(Loading()) {
    on<EmailLogin>((event, emit) async {
      emit(Loading());
      bool havePermission = false;
      final pro = await userReference.get();
      for (var doc in pro.docs) {
        var s = doc.data();
        var curUser = User(
          id: doc.id,
          name: s["name"] ?? "Unnamed",
          phoneNumber: s["phoneNumber"] ?? "",
          email: s["email"],
          isActive: s["isActive"] ?? true,
          avatarUrl: s["avatarUrl"] ?? "https://img.freepik.com/free-icon/user_318-159711.jpg",
          isAdmin: s["isAdmin"] ?? false,
          isStaff: s["isStaff"] ?? false,
          isSuperAdmin: s["isSuperAdmin"] ?? false,
        );
        if (event.email == curUser.email && (curUser.isSuperAdmin || curUser.isAdmin)) {
          havePermission = true;
          break;
        }
      }

      if (!havePermission) {
        emit(UnAuthenticated(message: 'Permission denied!', pageState: Login()));
        return;
      }
      var user = await _authAPI.emailLogin(event.email, event.password);
      // print(user);
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(UnAuthenticated(message: 'Email or password is wrong!', pageState: Login()));
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
