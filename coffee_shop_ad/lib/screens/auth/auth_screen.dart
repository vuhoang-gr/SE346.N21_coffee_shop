import 'package:coffee_shop_admin/screens/auth/login_screen.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth_screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimension.height32),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimension.getWidthFromValue(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: AppText.style.boldBlack16.copyWith(
                        fontSize: Dimension.getWidthFromValue(34),
                      ),
                    ),
                    //Body
                    Expanded(
                      flex:
                          MediaQuery.of(context).viewInsets.bottom == 0 ? 3 : 1,
                      child: SingleChildScrollView(
                          physics: MediaQuery.of(context).viewInsets.bottom == 0
                              ? NeverScrollableScrollPhysics()
                              : BouncingScrollPhysics(),
                          child: LoginScreen()),
                    ),
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
