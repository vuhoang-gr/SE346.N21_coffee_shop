part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class UnAuthenticated extends AuthState {
  final String? message;
  UnAuthenticated({this.message, pageState}) {
    authActionState = pageState ?? Login();
  }
  late AuthActionState authActionState;
  @override
  List<Object?> get props => [message, authActionState];
}

class Authenticated extends AuthState {
  final User user;
  Authenticated({required this.user});
  @override
  List<Object?> get props => [user];
}

class Loading extends AuthState {}
