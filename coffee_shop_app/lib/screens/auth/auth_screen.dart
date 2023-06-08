import 'package:coffee_shop_app/screens/auth/forgot_password_screen.dart';
import 'package:coffee_shop_app/screens/auth/login_screen.dart';
import 'package:coffee_shop_app/screens/auth/sign_up_screen.dart';
import 'package:coffee_shop_app/utils/constants/dimension.dart';
import 'package:coffee_shop_app/utils/constants/social_enum.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/widgets/feature/login_screen/back_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/auth/auth_bloc.dart';
import '../../services/blocs/auth_action/auth_action_cubit.dart';
import '../../widgets/feature/login_screen/social_button.dart';

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
              resizeToAvoidBottomInset: false,
              body: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Back button
                  state is! SignIn
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
                            state is Login
                                ? 'Đăng nhập'
                                : state is ForgotPassword
                                    ? 'Quên mật khẩu'
                                    : 'Đăng ký',
                            style: AppText.style.boldBlack16.copyWith(
                              fontSize: Dimension.getWidthFromValue(34),
                            ),
                          ),
                          //Body
                          Expanded(
                            flex: MediaQuery.of(context).viewInsets.bottom == 0
                                ? 3
                                : 1,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: state is Login
                                  ? LoginScreen()
                                  : state is ForgotPassword
                                      ? ForgotPasswordScreen(
                                          email:
                                              (state as ForgotPassword).email,
                                        )
                                      : SignUpScreen(),
                            ),
                          ),

                          //Footer
                          state is! ForgotPassword
                              ? Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          child: Text(
                                              'Hoặc ${state is Login ? 'đăng nhập' : 'đăng ký'} bằng mạng xã hội')),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Image.asset('assets/images/delivery_icon.png')
                                          SocialButton(
                                            type: Social.google,
                                          ),
                                          SizedBox(
                                            width:
                                                Dimension.getWidthFromValue(30),
                                          ),
                                          SocialButton(
                                            type: Social.facebook,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            Dimension.getHeightFromValue(39),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
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
