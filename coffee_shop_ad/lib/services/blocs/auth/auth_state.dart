part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated({required this.user});
  @override
  List<Object?> get props => [user];
}

class Loading extends AuthState {}
