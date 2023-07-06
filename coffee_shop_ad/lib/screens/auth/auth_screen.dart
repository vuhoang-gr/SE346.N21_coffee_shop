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
      if (authStatus is UnAuthenticated && authStatus.message != null && authStatus.message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authStatus.message)));
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
              resizeToAvoidBottomInset: false,
              body: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //body
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimension.getWidthFromValue(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: MediaQuery.of(context).viewInsets.bottom == 0 ? 4 : 2,
                            child: SingleChildScrollView(physics: BouncingScrollPhysics(), child: LoginScreen()),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(margin: EdgeInsets.only(bottom: 12), child: Text('Coffee Shop Admin')),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
