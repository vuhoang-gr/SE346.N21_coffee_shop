import 'package:coffee_shop_staff/screens/auth/forgot_password_screen.dart';
import 'package:coffee_shop_staff/screens/auth/login_screen.dart';
import 'package:coffee_shop_staff/utils/constants/dimension.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/auth/auth_bloc.dart';
import '../../services/blocs/auth_action/auth_action_cubit.dart';
import '../../widgets/features/login_screen/back_header.dart';

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
              if (state is Login) {
                return true;
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
                  //Back button
                  state is! Login
                      ? BackHeader()
                      : SizedBox(
                          height: Dimension.height32,
                        ),

                  //body
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimension.getWidthFromValue(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Header
                          Text(
                            state is Login ? 'Đăng nhập' : 'Quên mật khẩu',
                            style: AppText.style.boldBlack16.copyWith(
                              fontSize: Dimension.getFontSize(34),
                            ),
                          ),
                          //Body
                          Expanded(
                            flex: MediaQuery.of(context).viewInsets.bottom == 0
                                ? 3
                                : 1,
                            child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: Dimension.getHeightFromValue(50),
                                    ),
                                    state is ForgotPassword
                                        ? ForgotPasswordScreen(
                                            email: state.email,
                                          )
                                        : LoginScreen(),
                                  ],
                                )),
                          ),
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
