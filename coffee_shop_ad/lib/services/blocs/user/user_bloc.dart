import 'dart:async';

import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/blocs/user/user_event.dart';
import 'package:coffee_shop_admin/services/blocs/user/user_state.dart';
import 'package:coffee_shop_admin/services/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(LoadingState()) {
    on<FetchData>(_mapFetchData);
  }

  Future<void> _mapFetchData(FetchData event, Emitter<UserState> emit) async {
    emit(LoadingState());
    final pro = await userReference.get();
    List<User> users = [];
    pro.docs.forEach((doc) {
      var s = doc.data();

      users.add(User(
          id: doc.id,
          name: s["name"] ?? "Unnamed",
          phoneNumber: s["phoneNumber"] ?? "",
          email: s["email"],
          isActive: s["isActive"] ?? true,
          avatarUrl: s["avatarUrl"] ?? "https://img.freepik.com/free-icon/user_318-159711.jpg",
          isAdmin: s["isAdmin"] ?? false,
          isStaff: s["isStaff"] ?? false));
    });

    users.sort((a, b) {
      int A = 0, B = 0;
      if (a.isAdmin) A += 10;
      if (a.isStaff) A++;
      if (b.isAdmin) B += 10;
      if (b.isStaff) B++;

      if (A < B) {
        return 1;
      } else if (A > B) {
        return -1;
      }

      return 0;
    });

    emit(LoadedState(
      users: users,
    ));
  }
}
