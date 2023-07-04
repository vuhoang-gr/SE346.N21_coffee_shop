import 'package:coffee_shop_app/services/apis/auth_api.dart';
import 'package:coffee_shop_app/services/blocs/app_cubit/app_cubit.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/constants/dimension.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/utils/validations/confirm_password_validate.dart';
import 'package:coffee_shop_app/utils/validations/email_validate.dart';
import 'package:coffee_shop_app/utils/validations/password_validate.dart';
import 'package:coffee_shop_app/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/blocs/auth_action/auth_action_cubit.dart';
import '../../widgets/global/buttons/rounded_button.dart';
import '../../widgets/global/textForm/custom_text_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool canSignUp() {
      if (EmailValidator().validate(emailController.text) &&
          PasswordValidator().validate(passwordController.text) &&
          ConfirmPasswordValidator(oldPassword: passwordController)
              .validate(confirmController.text)) {
        return true;
      }
      return false;
    }

    onSignUp() async {
      if (!canSignUp()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something is wrong. Try again!'),
          ),
        );
        return;
      }

      if (context.mounted) {
        context.read<AppCubit>().changeState(AppLoading());
      }

      await AuthAPI()
          .emailSignUp(emailController.text, passwordController.text);
      if (context.mounted) {
        context
            .read<AuthActionCubit>()
            .changeState(Login(email: emailController.text));
        context.read<AppCubit>().changeState(AppLoaded());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up successed!'),
          ),
        );
      }
    }

    var status = context.watch<AuthActionCubit>().state;
    if (status is SignIn) {
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
        CustormTextForm(
          controller: confirmController,
          validator: ConfirmPasswordValidator(oldPassword: passwordController),
          verifiedCheck: true,
          secure: true,
          label: 'Nhập lại mật khẩu',
          margin: EdgeInsets.only(bottom: Dimension.getHeightFromValue(15)),
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
                  .changeState(Login(email: emailController.text));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Bạn đã có tài khoản?',
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
          onPressed: onSignUp,
          label: "Đăng ký",
        ),
      ],
    );
  }
}
