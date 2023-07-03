part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailLogin extends AuthEvent {
  final String email;
  final String password;
  EmailLogin({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogOut extends AuthEvent {}

class SetLoading extends AuthEvent {}

class UserChanged extends AuthEvent {
  final User? user;
  UserChanged({required this.user});
  @override
  List<Object?> get props => [user];
}
