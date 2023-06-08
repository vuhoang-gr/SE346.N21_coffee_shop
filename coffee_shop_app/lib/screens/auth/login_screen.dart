import 'package:coffee_shop_app/services/apis/auth_api.dart';
import 'package:coffee_shop_app/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/constants/dimension.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/utils/validations/email_validate.dart';
import 'package:coffee_shop_app/utils/validations/password_validate.dart';
import 'package:coffee_shop_app/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/blocs/auth_action/auth_action_cubit.dart';
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
    bool canLogin() {
      if (EmailValidator().validate(emailController.text) &&
          PasswordValidator().validate(passwordController.text)) {
        return true;
      }
      return false;
    }

    onLogin() async {
      if (!canLogin()) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something is wrong! Try again!')));
        return;
      }
      context.read<AuthBloc>().add(EmailLogin(
          email: emailController.text, password: passwordController.text));
    }

    var status = context.watch<AuthActionCubit>().state;
    if (status is Login) {
      if (status.email != null && status.email!.isNotEmpty) {
        emailController.text = status.email!;
      }
    }
    return Column(
      children: [
        SizedBox(
          height: Dimension.getHeightFromValue(72),
        ),
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
          label: 'Mật khẩu',
          margin:
              EdgeInsets.symmetric(vertical: Dimension.getHeightFromValue(15)),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: Dimension.getHeightFromValue(39),
            top: Dimension.getHeightFromValue(9),
          ),
          child: TouchableOpacity(
            onTap: () {
              context
                  .read<AuthActionCubit>()
                  .changeState(ForgotPassword(email: emailController.text));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Quên mật khẩu?',
                  style: AppText.style.regularBlack10.copyWith(
                    fontSize: Dimension.getWidthFromValue(15),
                  ),
                ),
                Icon(
                  Icons.arrow_right_alt,
                  color: AppColors.blueColor,
                )
              ],
            ),
          ),
        ),
        RoundedButton(
          onPressed: onLogin,
          label: "Đăng nhập",
        ),
      ],
    );
  }
}
