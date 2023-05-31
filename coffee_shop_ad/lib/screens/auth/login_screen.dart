import 'package:coffee_shop_admin/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/utils/validations/email_validate.dart';
import 'package:coffee_shop_admin/utils/validations/password_validate.dart';
import 'package:coffee_shop_admin/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/global/buttons/rounded_button.dart';
import '../../widgets/global/textForm/custom_text_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    onLogin() async {
      context.read<AuthBloc>().add(EmailLogin(
          email: emailController.text, password: passwordController.text));
    }

    return Column(
      children: [
        Image.asset('assets/images/pickup_icon.png'),
        CustormTextForm(
          controller: emailController,
          validator: EmailValidator(),
          verifiedCheck: true,
          label: 'Email',
        ),
        CustormTextForm(
          controller: passwordController,
          validator: PasswordValidator(),
          verifiedCheck: true,
          secure: true,
          label: 'Password',
          margin:
              EdgeInsets.symmetric(vertical: Dimension.getHeightFromValue(15)),
        ),
        RoundedButton(
          onPressed: onLogin,
          label: "LOGIN",
        ),
      ],
    );
  }
}
