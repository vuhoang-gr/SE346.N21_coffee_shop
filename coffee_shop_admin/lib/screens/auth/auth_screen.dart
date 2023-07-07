import 'package:coffee_shop_admin/screens/auth/login_screen.dart';
import 'package:coffee_shop_admin/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/auth_action/auth_action_cubit.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth_screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

// enum AuthState { login, signup, loggedIn }

class _AuthScreenState extends State<AuthScreen> {
  late dynamic authStatus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authStatus = context.watch<AuthBloc>().state;
    if (authStatus is UnAuthenticated) {
      context.read<AuthActionCubit>().changeState(authStatus.authActionState);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (authStatus is UnAuthenticated &&
          authStatus.message != null &&
          authStatus.message.isNotEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(authStatus.message)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AuthActionCubit, AuthActionState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (state is SignIn) {
                return true;
              } else if (state is Login) {
                context.read<AuthActionCubit>().changeState(SignIn());
                return false;
              } else {
                context.read<AuthActionCubit>().changeState(Login());
                return false;
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimension.getWidthFromValue(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: LoginScreen()),
                    ),
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: Text('Coffee Shop Admin'))
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
