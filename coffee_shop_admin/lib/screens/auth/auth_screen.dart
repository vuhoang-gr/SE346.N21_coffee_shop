import 'package:coffee_shop_admin/screens/auth/forgot_password_screen.dart';
import 'package:coffee_shop_admin/screens/auth/login_screen.dart';
import 'package:coffee_shop_admin/screens/auth/sign_up_screen.dart';
import 'package:coffee_shop_admin/services/blocs/auth_cubit/auth_cubit.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/features/login_screen/back_header.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

// enum AuthState { login, signup, loggedIn }

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    AuthState status = context.watch<AuthCubit>().state;

    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Back button
            status is! SignIn
                ? BackHeader()
                : SizedBox(
                    height: Dimension.height32,
                  ),
            //body
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimension.getWidthFromValue(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Header
                    Text(
                      status is Login
                          ? 'Login'
                          : status is ForgotPassword
                              ? 'Forgot password'
                              : 'Sign up',
                      style: AppText.style.boldBlack16.copyWith(
                        fontSize: Dimension.getWidthFromValue(34),
                      ),
                    ),
                    //Body
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        physics: MediaQuery.of(context).viewInsets.bottom == 0
                            ? NeverScrollableScrollPhysics()
                            : BouncingScrollPhysics(),
                        child: status is Login
                            ? LoginScreen()
                            : status is ForgotPassword
                                ? ForgotPasswordScreen(
                                    email: status.email,
                                  )
                                : SignUpScreen(),
                      ),
                    ),

                    //Footer
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
