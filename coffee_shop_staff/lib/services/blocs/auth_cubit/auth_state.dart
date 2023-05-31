part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Login extends AuthState {
  final String? email;
  Login({this.email});
  @override
  List<Object?> get props => [email];
}

class SignIn extends AuthState {}

class ForgotPassword extends AuthState {
  final String? email;
  ForgotPassword({this.email});
  @override
  List<Object?> get props => [email];
}
