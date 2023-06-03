import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/services/blocs/user/user_event.dart';
import 'package:coffee_shop_admin/services/blocs/user/user_state.dart';
import 'package:coffee_shop_admin/services/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(LoadingState()) {
    on<FetchData>(_mapFetchData);
  }

  Future<void> _mapFetchData(FetchData event, Emitter<UserState> emit) async {
    final pro = await FirebaseFirestore.instance.collection("users").get();
    List<User> users = [];
    pro.docs.forEach((doc) {
      var s = doc.data();
      users.add(User(
          id: doc.id,
          name: s["name"] ?? "Unnamed",
          phoneNumber: s["phoneNumber"] ?? "",
          email: s["email"],
          isActive: s["isActive"] ?? true,
          avatarUrl: s["avatarUrl"] ??
              "https://img.freepik.com/free-icon/user_318-159711.jpg",
          isAdmin: s["isAdmin"] ?? false,
          isStaff: s["isStaff"] ?? false));
    });

    emit(LoadingState());
    await Future.delayed(const Duration(seconds: 1), () {
      emit(LoadedState(
        users: users,
      ));
    });
  }
}
