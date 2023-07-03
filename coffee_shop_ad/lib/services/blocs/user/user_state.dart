import 'package:coffee_shop_admin/services/models/user.dart';

abstract class UserState {
  UserState();
}

class LoadingState extends UserState {
  LoadingState();
}

class ErrorState extends UserState {
  ErrorState();
}

class LoadedState extends UserState {
  final List<User> users;

  LoadedState({
    required this.users,
  });
}
