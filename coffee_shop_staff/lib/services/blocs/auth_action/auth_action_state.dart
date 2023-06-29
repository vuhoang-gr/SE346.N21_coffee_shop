part of 'auth_action_cubit.dart';

@immutable
abstract class AuthActionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Login extends AuthActionState {
  final String? email;
  Login({this.email});
  @override
  List<Object?> get props => [email];
}

class ForgotPassword extends AuthActionState {
  final String? email;
  ForgotPassword({this.email});
  @override
  List<Object?> get props => [email];
}
